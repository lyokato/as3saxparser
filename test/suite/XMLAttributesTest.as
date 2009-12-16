package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXInternalParser;
    import org.coderepos.xml.sax.XMLSAXParserConfig;
    import org.coderepos.xml.sax.IXMLSAXHandler;
    import org.coderepos.xml.XMLAttributes;

    import flash.utils.ByteArray;

    public class XMLAttributesTest extends TestCase implements IXMLSAXHandler
    {
        private var _results:Array = [];

        public function XMLAttributesTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLAttributesTest("testParser") );
            return ts;
        }

        public function testParser():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            var parser:XMLSAXInternalParser = new XMLSAXInternalParser(config);
            parser.handler = this;
            parser.parseChunk("<foo xmlns='http://example.org/' xmlns:bar='http://example.org/bar' hoge='buz' bar:aaa='bbb'>");
            parser.parseChunk("</foo>");
        }

        public function startDocument():void {
            _results.push("startDocument");
        }

        public function endDocument():void {
            _results.push("endDocument");
        }
        public function startElement(ns:String, name:String, attr:XMLAttributes, depth:uint):void {
            var hoge:String = attr.getValue("hoge");
            assertEquals("XMLAttributes.getValue works correctly.", "buz", hoge);
            var bar:String = attr.getValueWithPrefix('bar', 'aaa');
            assertEquals("XMLAttributes.getValueWithPrefix works correctly.", "bbb", bar);
        }
        public function endElement(ns:String, name:String, depth:uint):void {
        }
        public function characters(s:String):void {
        }
        public function cdata(s:String):void {
        }
        public function comment(s:String):void {
        }
    }
}

