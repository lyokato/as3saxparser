package org.coderepos.xml.sax
{
    import flash.utils.ByteArray;
    import org.coderepos.xml.XMLUtil;
    import org.coderepos.xml.exceptions.XMLFragmentSizeOverError;

    public class XMLFragmentSplitter
    {
        private var _buffer:ByteArray;
        private var _parsedAtLeastOneFragment:Boolean;
        private var _MAX_FRAGMENT_SIZE:uint;

        public function XMLFragmentSplitter(config:XMLSAXParserConfig)
        {
            _buffer = new ByteArray();
            _parsedAtLeastOneFragment = false;
            _MAX_FRAGMENT_SIZE = config.MAX_FRAGMENT_SIZE;
        }

        public function get bufferLength():int
        {
            return _buffer.length;
        }

        public function pushBytes(b:ByteArray):void
        {
            var pos:int = _buffer.position;
            _buffer.position = _buffer.length;
            b.position = 0;
            _buffer.writeBytes(b, 0, b.length);
            _buffer.position = pos;
        }

        public function splitFragment():String
        {
            if (_buffer.bytesAvailable == 0)
                return null;

            var startPos:int  = _buffer.position;
            var first:uint    = _buffer.readUnsignedByte();
            var isTag:Boolean = (first == XMLUtil.TAG_START_CHARCODE);

            var isComment:Boolean    = false;
            var isCDATA:Boolean      = false;
            var reachedToEnd:Boolean = false;

            var i:int = 1;
            var temp:int;

            while (_buffer.bytesAvailable > 0) {

                var ch:uint = _buffer.readUnsignedByte();
                i++;

                if (i == 4 && isTag) {
                    temp = _buffer.position;
                    _buffer.position = startPos;
                    if (_buffer.readUTFBytes(4) == "<!--")
                        isComment = true;
                    _buffer.position = temp;
                }

                if (i == 9 && isTag && !isComment) {
                    temp = _buffer.position;
                    _buffer.position = startPos;
                    if (_buffer.readUTFBytes(9) == "<![CDATA[")
                        isCDATA = true;
                    _buffer.position = temp;
                }

                if (i > _MAX_FRAGMENT_SIZE) {
                    throw new XMLFragmentSizeOverError(
                        "fragment size is over " + _MAX_FRAGMENT_SIZE);
                }

                if (isTag && ch == XMLUtil.TAG_END_CHARCODE) {
                    var last1:uint;
                    var last2:uint;
                    if (isComment) {
                        temp = _buffer.position;
                        _buffer.position = temp - 3;
                        last1 = _buffer.readUnsignedByte();
                        last2 = _buffer.readUnsignedByte();
                        _buffer.position = temp;
                        if (   last1 == XMLUtil.HYPHEN_CHARCODE
                            && last2 == XMLUtil.HYPHEN_CHARCODE)
                            reachedToEnd = true;
                    }
                    else if (isCDATA) {
                        temp = _buffer.position;
                        _buffer.position = temp - 3;
                        last1 = _buffer.readUnsignedByte();
                        last2 = _buffer.readUnsignedByte();
                        _buffer.position = temp;
                        if (   last1 == XMLUtil.RBRA_CHARCODE
                            && last2 == XMLUtil.RBRA_CHARCODE)
                            reachedToEnd = true;
                    } else {
                        reachedToEnd = true;
                    }
                }

                if (!isTag && ch == XMLUtil.TAG_START_CHARCODE) {
                    _buffer.position--;
                    reachedToEnd = true;
                }

                if (reachedToEnd) {
                    var fragment:ByteArray = new ByteArray();
                    fragment.writeBytes(_buffer, startPos, _buffer.position - startPos);
                    fragment.position = 0;
                    _parsedAtLeastOneFragment = true;
                    return fragment.readUTFBytes(fragment.length);
                }
            }
            _buffer.position = startPos;
            return null;
        }

        public function discardRead():void
        {
            if (_parsedAtLeastOneFragment) {
                var rest:ByteArray = new ByteArray();
                if (_buffer.bytesAvailable > 0)
                    rest.writeBytes(_buffer, _buffer.position, _buffer.bytesAvailable);
                _buffer = rest;
                _buffer.position = 0;
                _parsedAtLeastOneFragment = false;
            }
        }
    }
}

