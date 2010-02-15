package org.coderepos.xml
{
    public class XMLElement
    {
        private var _ns:String;
        private var _localName:String;
        private var _attrs:XMLAttributes;
        private var _texts:Array; // Vector.<String>
        private var _children:Object; // Map.<String, Vector.<XMLElementBuffer>>;

        public function XMLElement(ns:String, localName:String,
            attrs:XMLAttributes, texts:Array, children:Object)
        {
            _ns        = ns;
            _localName = localName;
            _attrs     = attrs;
            _texts     = texts;
            _children  = children;
        }

        public function match(ns:String, localName:String):Boolean
        {
            return (_ns == ns && _localName == localName);
        }

        public function get ns():String
        {
            return _ns;
        }

        public function getElements(localName:String):Array
        {
            return getElementsNS(_ns, localName);
        }

        public function getElementsNS(ns:String, localName:String):Array
        {
            var id:String = XMLUtil.genElementSig(ns, localName);
            return (id in _children) ? _children[id] : [];
        }

        public function getFirstElement(localName:String):XMLElement
        {
            return getFirstElementNS(_ns, localName);
        }

        public function getFirstElementNS(ns:String, localName:String):XMLElement
        {
            var id:String = XMLUtil.genElementSig(ns, localName);
            return (id in _children) ? _children[id][0] : null;
        }

        public function get localName():String
        {
            return _localName;
        }

        public function getAttr(attrName:String):String
        {
            return _attrs.getValue(attrName);
        }

        public function getAttrNS(ns:String, attrName:String):String
        {
            return _attrs.getValueWithURI(ns, attrName);
        }

        public function get texts():Array
        {
            return _texts;
        }

        public function get text():String
        {
            return _texts.join("");
        }

    }
}

