package org.coderepos.xml.sax
{
    import org.coderepos.xml.XMLAttributes;

    // this class behaves as a null object or an abstract class.
    public class XMLSAXDefaultHandler implements IXMLSAXHandler
    {
        public function XMLSAXDefaultHandler()
        {

        }

        public function startDocument():void
        {
            // do nothing
            // define in subclass
        }

        public function endDocument():void
        {
            // do nothing
            // define in subclass
        }

        public function startElement(ns:String, localName:String, attrs:XMLAttributes, depth:uint):void
        {
            // do nothing
            // define in subclass
        }

        public function endElement(ns:String, localName:String, depth:uint):void
        {
            // do nothing
            // define in subclass
        }

        public function cdata(str:String):void
        {
            // do nothing
            // define in subclass
        }

        public function characters(str:String):void
        {
            // do nothing
            // define in subclass
        }

        public function comment(str:String):void
        {
            // do nothing
            // define in subclass
        }

    }
}

