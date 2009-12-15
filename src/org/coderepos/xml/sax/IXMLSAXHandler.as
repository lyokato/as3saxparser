package org.coderepos.xml.sax
{
    import org.coderepos.xml.XMLAttributes;

    public interface IXMLSAXHandler
    {
        function startDocument():void;
        function endDocument():void;
        function startElement(ns:String, localName:String, attributes:XMLAttributes, depth:uint):void;
        function endElement(ns:String, localName:String, depth:uint):void;
        function characters(str:String):void;
        function cdata(str:String):void;
        function comment(str:String):void;
    }
}

