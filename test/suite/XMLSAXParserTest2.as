package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXParser;
    import org.coderepos.xml.XMLAttributes;
    import org.coderepos.xml.sax.IXMLSAXHandler;

    import flash.utils.ByteArray;

    public class XMLSAXParserTest2 extends TestCase
    {
        private var _handler:TestHandler;

        public function XMLSAXParserTest2(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLSAXParserTest2("testParse") );
            return ts;
        }

        public function testParse():void
        {

            var xmlString:String = " <foo xmlns='http://example.org/' xmlns:bar='http://example.org/bar' hoge='buz'>data<bar:child>data2</bar:child>";
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(xmlString);

            var parser:XMLSAXParser = new XMLSAXParser();
            parser.handler = new TestHandler(this);
            parser.pushBytes(bytes);

            var xmlString2:String = "<br /></foo>";
            var bytes2:ByteArray = new ByteArray();
            bytes2.writeUTFBytes(xmlString2);
            parser.pushBytes(bytes2);
        }
        public function finish(_results:Array):void {
            assertEquals(_results[0], "startDocument");
            assertEquals(_results[1], "element[http://example.org/:foo:0]");
            assertEquals(_results[2], "ATTR[http://example.org/:hoge:buz]");
            assertEquals(_results[3], "CHARS[data]");
            assertEquals(_results[4], "element[http://example.org/bar:child:1]");
            assertEquals(_results[5], "CHARS[data2]");
            assertEquals(_results[6], "endElement[http://example.org/bar:child:1]");
            assertEquals(_results[7], "element[http://example.org/:br:1]");
            assertEquals(_results[8], "endElement[http://example.org/:br:1]");
            assertEquals(_results[9], "endElement[http://example.org/:foo:0]");

        }

    }
}
