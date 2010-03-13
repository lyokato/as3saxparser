package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXInternalParser;
    import org.coderepos.xml.sax.XMLSAXParserConfig;
    import org.coderepos.xml.sax.IXMLSAXHandler;
    import org.coderepos.xml.XMLAttributes;

    import flash.utils.ByteArray;

    public class XMLSAXInternalParserTest extends TestCase implements IXMLSAXHandler
    {
        private var _state:String = "";

        public function XMLSAXInternalParserTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLSAXInternalParserTest("testParser") );
            return ts;
        }

        public function testParser():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            var parser:XMLSAXInternalParser = new XMLSAXInternalParser(config);
            parser.handler = this;
            parser.parseChunk("<foo>");
            parser.parseChunk("data");
            parser.parseChunk("<![CDATA[ hoge > ]]>");
            parser.parseChunk("<!-- foobarbuz -->");
            parser.parseChunk("<br hoge='test'/>");
            parser.parseChunk("</foo>");
        }

        public function startDocument():void {
            _state += "startDocument:";
        }

        public function endDocument():void {
            _state += "endDocument:";
            assertEquals("state check", "startDocument:element[null:foo:0]:CHARS[data]:CDATA[hoge >]:COMMENT[foobarbuz]:element[null:br:1]:endElement[null:br:1]:endElement[null:foo:0]:endDocument:", _state);
        }
        public function startElement(ns:String, name:String, attr:XMLAttributes, depth:uint):void {
            _state += "element[" + ns + ":" + name + ":" + String(depth) + "]:";
        }
        public function endElement(ns:String, name:String, depth:uint):void {
            _state += "endElement[" + ns + ":" + name + ":" + String(depth) + "]:";
        }
        public function characters(s:String):void {
            _state += "CHARS[" + s;
            _state += "]:";
        }
        public function cdata(s:String):void {
            _state += "CDATA[" + s + "]:" ;
        }
        public function comment(s:String):void { 
            _state += "COMMENT[" + s + "]:" ;
        }
    }
}

