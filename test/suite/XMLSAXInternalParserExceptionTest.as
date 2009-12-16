package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLSAXInternalParser;
    import org.coderepos.xml.sax.XMLSAXParserConfig;
    import org.coderepos.xml.sax.IXMLSAXHandler;
    import org.coderepos.xml.XMLAttributes;
    import org.coderepos.xml.exceptions.XMLElementDepthOverError;

    import flash.utils.ByteArray;

    public class XMLSAXInternalParserExceptionTest extends TestCase implements IXMLSAXHandler
    {
        private var _state:String = "";

        public function XMLSAXInternalParserExceptionTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLSAXInternalParserExceptionTest("testParser") );
            return ts;
        }

        public function testParser():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            config.MAX_ELEMENT_DEPTH = 2;

            var parser:XMLSAXInternalParser = new XMLSAXInternalParser(config);
            parser.handler = this;
            parser.parseChunk("<depth1>");
            parser.parseChunk("<depth2>");
            var elementDepthOver:Boolean = false;
            try {
                parser.parseChunk("<depth3>");
            } catch (e:*) {
                if (e is XMLElementDepthOverError) {
                    elementDepthOver = true;
                } else {
                    throw e;
                }
            }
            assertTrue(elementDepthOver);
            //parser.parseChunk("</depth3>");
            //parser.parseChunk("</depth2>");
            //parser.parseChunk("</depth1>");
        }

        public function startDocument():void {
        }

        public function endDocument():void {
        }
        public function startElement(ns:String, name:String, attr:XMLAttributes, depth:uint):void {
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

