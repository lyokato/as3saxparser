package org.coderepos.xml.sax
{
    import org.coderepos.xml.XMLUtil;
    import org.coderepos.xml.XMLElementBuffer;
    import org.coderepos.xml.XMLElement;
    import org.coderepos.xml.XMLAttributes;

    public class XMLElementEventHandler implements IXMLSAXHandler
    {
        private var _currentBuffer:XMLElementBuffer;
        private var _currentCallback:Function;
        private var _events:Array;
        private var _rootEvent:Object;

        public function XMLElementEventHandler()
        {
            _currentBuffer   = null;
            _currentCallback = null;
            _events          = [];
            _rootEvent       = {};
        }

        public function registerRootElementAttributeEvent(ns:String, localName:String,
            callback:Function):void
        {
            var id:String = XMLUtil.genElementSig(ns, localName);
            _rootEvent[id] = callback;
        }

        public function registerElementEvent(ns:String, localName:String,
            depth:uint, callback:Function):void
        {
            if (_events[depth] == null)
                _events[depth] = {};

            var id:String = XMLUtil.genElementSig(ns, localName);
            _events[depth][id] = callback;
        }

        // IXMLSAXHandler interface
        public function startDocument():void
        {
        }

        public function endDocument():void
        {
        }

        public function startElement(ns:String, localName:String,
            attrs:XMLAttributes, depth:uint):void
        {
            var id:String = XMLUtil.genElementSig(ns, localName);

            if (depth == 0 && id in _rootEvent)
               _rootEvent[id](attrs);

            if (_currentBuffer == null) {
                if (_events[depth] != null) {
                    if (id in _events[depth])
                        _currentCallback = _events[depth][id];
                        _currentBuffer = new XMLElementBuffer(ns, localName, attrs, depth);
                }
            } else {
                _currentBuffer.startCapturingDescendant(ns, localName, attrs, depth);
            }
        }

        public function endElement(ns:String, localName:String, depth:uint):void
        {

            if (_currentBuffer != null) {
                if (_currentBuffer.match(ns, localName, depth)) {
                    var elem:XMLElement   = _currentBuffer.toElement();
                    var callback:Function = _currentCallback;
                    _currentBuffer   = null;
                    _currentCallback = null;
                    callback(elem);
                } else if (_currentBuffer.isCapturingDescendant(ns, localName, depth)) {
                    _currentBuffer.finishCapturingDescendant(ns, localName, depth);
                }
            }
        }

        public function characters(str:String):void
        {
            if (_currentBuffer != null)
                _currentBuffer.pushText(str);
        }

        public function cdata(str:String):void
        {
            if (_currentBuffer != null)
                _currentBuffer.pushText(str);
        }

        public function comment(str:String):void
        {
        }
    }
}

