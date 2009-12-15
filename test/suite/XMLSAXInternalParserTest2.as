package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXInternalParser;
    import org.coderepos.xml.sax.XMLSAXParserConfig;
    import org.coderepos.xml.sax.IXMLSAXHandler;
    import org.coderepos.xml.XMLAttributes;

    import flash.utils.ByteArray;

    public class XMLSAXInternalParserTest2 extends TestCase implements IXMLSAXHandler
    {
        private var _results:Array = [];

        public function XMLSAXInternalParserTest2(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLSAXInternalParserTest2("testParser") );
            return ts;
        }

        public function testParser():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            var parser:XMLSAXInternalParser = new XMLSAXInternalParser(config);
            parser.handler = this;
            parser.parseChunk("<foo xmlns='http://example.org/' xmlns:bar='http://example.org/bar' hoge='buz'>");
            parser.parseChunk("data");
            parser.parseChunk("<bar:child>");
            parser.parseChunk("data2");
            parser.parseChunk("</bar:child>");
            parser.parseChunk("<br />");
            parser.parseChunk("</foo>");
        }

        public function startDocument():void {
            _results.push("startDocument");
        }

        public function endDocument():void {
            _results.push("endDocument");
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
        public function startElement(ns:String, name:String, attr:XMLAttributes, depth:uint):void {
            _results.push("element[" + ns + ":" + name + ":" + String(depth) + "]");
            var arr:Array = attr.toArray();
            for (var i:int=0; i<arr.length;i++) {
                _results.push("ATTR["+arr[i].uri+":"+ arr[i].name + ":" + arr[i].value + "]");
            }
        }
        public function endElement(ns:String, name:String, depth:uint):void {
            _results.push("endElement[" + ns + ":" + name + ":" + String(depth) + "]");
        }
        public function characters(s:String):void {
            _results.push("CHARS[" + s + "]");
        }
        public function cdata(s:String):void {
            _results.push("CDATA[" + s + "]");
        }
        public function comment(s:String):void { 
            _results.push("COMMENT[" + s + "]") ;
        }
    }
}
