package org.coderepos.xml
{
    public class XMLAttribute
    {
        private var _uri:String;
        private var _name:String;
        private var _value:String;

        public function XMLAttribute(uri:String, name:String, value:String)
        {
            _uri   = uri;
            _name  = name;
            _value = value;
        }

        public function get uri():String
        {
            return _uri;
        }

        public function get name():String
        {
            return _name;
        }

        public function get value():String
        {
            return _value;
        }
    }
}

