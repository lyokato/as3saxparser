package org.coderepos.xml.sax
{
    internal class XMLSAXInternalParserContext
    {
        public var pos:int;
        public var chunk:String;
        private var _length:int;

        public function XMLSAXInternalParserContext(ch:String)
        {
            pos   = 0;
            chunk = ch;
            _length = chunk.length;
        }

        public function get():String
        {
            return chunk.charAt(pos);
        }

        public function getAt(i:int):String
        {
            if (i + 1 >= _length)
                return null;
            return chunk.charAt(i);
        }

        public function next():String
        {
            if (pos + 1 >= _length)
                return null;
            return chunk.charAt(++pos);
        }
    }
}

