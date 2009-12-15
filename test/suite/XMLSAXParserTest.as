package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXParser;
    import org.coderepos.xml.XMLAttributes;
    import org.coderepos.xml.sax.IXMLSAXHandler;

    import flash.utils.ByteArray;

    public class XMLSAXParserTest extends TestCase implements IXMLSAXHandler
    {
        private var _results:Array = [];

        public function XMLSAXParserTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLSAXParserTest("testParse") );
            return ts;
        }

        public function testParse():void
        {

            var xmlString:String = "<foo xmlns='http://example.org/' xmlns:bar='http://example.org/bar' hoge='buz'>data<bar:child>data2</bar:child>";
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(xmlString);

            var parser:XMLSAXParser = new XMLSAXParser();
            parser.handler = this;
            parser.pushBytes(bytes);

            var xmlString2:String = "<br /></foo>";
            var bytes2:ByteArray = new ByteArray();
            bytes2.writeUTFBytes(xmlString2);
            parser.pushBytes(bytes2);
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
