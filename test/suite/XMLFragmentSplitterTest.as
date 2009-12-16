package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLFragmentSplitter;
    import org.coderepos.xml.sax.XMLSAXParserConfig;

    import flash.utils.ByteArray;

    public class XMLFragmentSplitterTest extends TestCase
    {
        public function XMLFragmentSplitterTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLFragmentSplitterTest("testSplit") );
            ts.addTest( new XMLFragmentSplitterTest("testSplitWithCommentAndCDATA") );
            ts.addTest( new XMLFragmentSplitterTest("testDiscard") );
            return ts;
        }

        public function testSplit():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            config.MAX_FRAGMENT_SIZE = 1024 * 100;

            var splitter:XMLFragmentSplitter = new XMLFragmentSplitter(config);

            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes("<foo>bar</foo>");
            splitter.pushBytes(bytes);
            var res1:String = splitter.splitFragment();
            assertEquals('first fragment should be <foo>', res1, '<foo>');
            var res2:String = splitter.splitFragment();
            assertEquals('second fragment should be bar', res2, 'bar');
            var res3:String = splitter.splitFragment();
            assertEquals('third fragment should be </foo>', res3, '</foo>');
            var res4:String = splitter.splitFragment();
            assertNull(res4);
        }

        public function testDiscard():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            config.MAX_FRAGMENT_SIZE = 1024 * 100;

            var splitter:XMLFragmentSplitter = new XMLFragmentSplitter(config);

            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes("<foo>bar</foo>");
            splitter.pushBytes(bytes);
            var res1:String = splitter.splitFragment();
            assertEquals('first fragment should be <foo>', res1, '<foo>');
            var res2:String = splitter.splitFragment();
            assertEquals('second fragment should be bar', res2, 'bar');

            assertEquals('bufferLength should be 14', splitter.bufferLength, '14');
            splitter.discardRead();
            assertEquals('bufferLength should be 6', splitter.bufferLength, '6');

            var res3:String = splitter.splitFragment();
            assertEquals('third fragment should be </foo>', res3, '</foo>');
            var res4:String = splitter.splitFragment();
            assertNull(res4);
        }

        public function testSplitWithCommentAndCDATA():void
        {
            var config:XMLSAXParserConfig = new XMLSAXParserConfig();
            config.MAX_FRAGMENT_SIZE = 1024 * 100;

            var splitter:XMLFragmentSplitter = new XMLFragmentSplitter(config);

            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes("<foo>bar<![CDATA[ hogehoge > ]]><!-- hogehoge > --></foo>");
            splitter.pushBytes(bytes);
            var res1:String = splitter.splitFragment();
            assertEquals('first fragment should be <foo>', res1, '<foo>');
            var res2:String = splitter.splitFragment();
            assertEquals('second fragment should be bar', res2, 'bar');
            var res3:String = splitter.splitFragment();
            assertEquals('third fragment should be <![CDATA[ hogehoge > ]]>', res3, '<![CDATA[ hogehoge > ]]>');
            var res4:String = splitter.splitFragment();
            assertEquals('fourth fragment should be <!-- hogehoge > -->', res4, '<!-- hogehoge > -->');
            var res5:String = splitter.splitFragment();
            assertEquals('fifth fragment should be </foo>', res5, '</foo>');
            var res6:String = splitter.splitFragment();
            assertNull(res6);
        }
    }
}

