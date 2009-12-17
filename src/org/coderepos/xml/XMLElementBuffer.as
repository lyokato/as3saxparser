package org.coderepos.xml
{
    public class XMLElementBuffer
    {
        private var _ns:String;
        private var _localName:String;
        private var _attrs:XMLAttributes;
        private var _depth:uint;
        private var _texts:Array; // Vector.<String>
        private var _children:Object; // Map.<String, Vector.<XMLElement>>;
        private var _currentChildBuffer:XMLElementBuffer;

        public function XMLElementBuffer(ns:String, localName:String,
            attrs:XMLAttributes, depth:uint)
        {
            _ns                 = ns;
            _localName          = localName;
            _attrs              = attrs;
            _depth              = depth;
            _texts              = [];
            _children           = {};
            _currentChildBuffer = null;
        }

        internal function getInternalID():String
        {
            return XMLUtil.genElementSig(_ns, _localName);
        }

        public function match(ns:String, localName:String, depth:uint):Boolean
        {
            return (_ns == ns && _localName == localName && _depth == depth);
        }

        public function pushText(str:String):void
        {
            if (_currentChildBuffer == null)
                _texts.push(str);
            else
                _currentChildBuffer.pushText(str);
        }

        public function startCapturingDescendant(ns:String, localName:String,
            attrs:XMLAttributes, depth:uint):void
        {
            if (_currentChildBuffer == null) {
                if (depth != _depth + 1)
                    throw new Error("Invalid element depth");

                _currentChildBuffer =
                    new XMLElementBuffer(ns, localName, attrs, depth);

            } else {
                _currentChildBuffer.startCapturingDescendant(ns, localName, attrs, depth);
            }
        }

        public function isCapturingDescendant(ns:String, localName:String,
            depth:uint):Boolean
        {
            if (_currentChildBuffer == null)
                return false;

            if (depth == _depth + 1)
                return _currentChildBuffer.match(ns, localName, depth);
            else if (depth > _depth + 1)
                return _currentChildBuffer.isCapturingDescendant(ns, localName, depth);
            else
                return false;
        }

        public function finishCapturingDescendant(ns:String, localName:String,
            depth:uint):void
        {
            if (!isCapturingDescendant(ns, localName, depth))
                throw new Error("Invalid element.");

            if (depth == _depth + 1) {
                var internalID:String = _currentChildBuffer.getInternalID();
                if (!(internalID in _children))
                    _children[internalID] = [];
                _children[internalID].push(_currentChildBuffer.toElement());
                _currentChildBuffer = null;
            } else if(depth > _depth + 1) {
                _currentChildBuffer.finishCapturingDescendant(ns, localName, depth);
            }
        }

        public function toElement():XMLElement
        {
            return new XMLElement(_ns, _localName, _attrs, _texts, _children);
        }
    }
}

