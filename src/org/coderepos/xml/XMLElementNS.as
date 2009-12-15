package org.coderepos.xml
{
    public class XMLElementNS
    {
        private var _uri:String;
        private var _dict:Object;
        private var _parent:XMLElementNS;

        public function XMLElementNS(uri:String, parent:XMLElementNS)
        {
            _dict   = { };
            _uri    = uri;
            _parent = parent;
        }

        // XXX: public -> internal?
        public function getParent():XMLElementNS
        {
            return _parent;
        }

        public function addNamespace(prefix:String, uri:String):void
        {
            _dict[prefix] = uri;
        }

        public function getURI():String
        {
            if (_uri != null)
                return _uri;
            else if (_parent != null)
                return _parent.getURI();
            else
                return null;
        }

        public function getURIForPrefix(prefix:String):String
        {
            if (prefix == null)
                return getURI();

            else if (prefix in _dict[prefix]) {
                return _dict[prefix];
            } else {
                if (_parent == null)
                    return null;
                return _parent.getURIForPrefix(prefix);
            }
        }
    }
}

