package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLFragmentSplitter;
    import org.coderepos.xml.sax.XMLSAXParserConfig;
    import org.coderepos.xml.exceptions.XMLFragmentSizeOverError;

    import flash.utils.ByteArray;

    public class XMLFragmentSplitterExceptionTest extends TestCase
    {
        public function XMLFragmentSplitterExceptionTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLFragmentSplitterExceptionTest("testSplit") );
            return ts;
        }

        public function testSplit():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            config.MAX_FRAGMENT_SIZE = 10;

            var splitter:XMLFragmentSplitter = new XMLFragmentSplitter(config);

            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes("<foo>size_is_over10</foo>");
            splitter.pushBytes(bytes);

            var res1:String = splitter.splitFragment();
            assertEquals('first fragment should be <foo>', res1, '<foo>');

            var sizeOverErrorIsThrown:Boolean = false;
            try {
                var res2:String = splitter.splitFragment();
            } catch (e:*) {
                if (e is XMLFragmentSizeOverError) {
                    sizeOverErrorIsThrown = true;
                } else {
                    throw e;
                }
            }
            assertTrue(sizeOverErrorIsThrown);
        }
    }
}

