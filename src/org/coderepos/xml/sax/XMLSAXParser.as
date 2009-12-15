package org.coderepos.xml
{
    import flash.utils.ByteArray;

    public class XMLSAXParser
    {
        private var _splitter:XMLFragmentSplitter;
        private var _internalParser:XMLSAXInternalParser;

        public function XMLSAXParser(config:XMLSAXParserConfig=null)
        {
            if (congig == null)
                config = new XMLSAXParserConfig();

            _splitter       = new XMLFragmentSplitter(config);
            _internalParser = new XMLSAXInternalParser(config);
        }

        public function set handler(handler:IXMLSAXHandler):void
        {
            _internalParser.handler = handler;
        }

        // @throws XMLSyntaxError, XMLFragmentSizeOverError
        public function pushBytes(bytes:ByteArray):void
        {
            _splitter.pushBytes(bytes);
            var fragment:String;
            while ((fragment = _splitter.splitFragment()) != null) {
                _internalParser.parseChunk(fragment);
            }
            _splitter.discardRead();
        }
    }
}

