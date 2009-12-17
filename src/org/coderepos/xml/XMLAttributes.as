package org.coderepos.xml
{
    import org.coderepos.xml.exceptions.XMLSyntaxError;

    public class XMLAttributes
    {
        private var _ns:XMLElementNS;
        private var _attrs:Object;

        public function XMLAttributes(ns:XMLElementNS)
        {
            _ns = ns;
            _attrs = {};
        }

        public function addAttribute(prefix:String,
            name:String, value:String):void
        {
            var uri:String = (prefix == null)
                ? _ns.getURI() : _ns.getURIForPrefix(prefix);
            if (uri == null)
                throw new XMLSyntaxError("Invalid prefix");

            if (!(uri in _attrs))
                _attrs[uri] = { };
            _attrs[uri][name] = value;
        }

        public function getValue(attrName:String):String
        {
            return getValueWithPrefix(null, attrName);
        }

        public function getValueWithPrefix(prefix:String,
            attrName:String):String
        {
            var uri:String = (prefix == null)
                ? _ns.getURI() : _ns.getURIForPrefix(prefix);

            return getValueWithURI(uri, attrName);
        }

        public function getValueWithURI(uri:String,
            attrName:String):String
        {
            if (uri == null)
                return null;

            if (!(uri in _attrs))
                return null;

            var map:Object = _attrs[uri];
            if (!(attrName in map))
                return null;

            return map[attrName];
        }

        public function toArray():Array
        {
            var results:Array = [];
            for (var uri:String in _attrs) {
                var map:Object = _attrs[uri];
                for (var name:String in map) {
                    results.push(new XMLAttribute(uri, name, map[name]));
                }
            }
            return results;
        }
    }
}

