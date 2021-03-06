package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.XMLUtil;

    import flash.utils.ByteArray;

    public class XMLUtilTest extends TestCase
    {
        public function XMLUtilTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLUtilTest("testEscape") );
            ts.addTest( new XMLUtilTest("testStrip") );
            return ts;
        }

        public function testEscape():void
        {
            var origin:String = "<foo> 'bar' \"buz\"";
            var escaped:String = XMLUtil.escapeXMLChar(origin);
            assertEquals(escaped, '&lt;foo&gt; &apos;bar&apos; &quot;buz&quot;');
            var unescaped:String = XMLUtil.unescapeXMLChar(escaped);
            assertEquals(unescaped, "<foo> 'bar' \"buz\"");
        }

        public function testStrip():void
        {
            var origin:String = "<foo>aaa<bbb> bbb</bbb></foo>";
            assertEquals('strip', XMLUtil.strip(origin), 'aaa bbb');
            var originBytes:ByteArray = new ByteArray();
            originBytes.writeUTFBytes(origin);
            originBytes.position = 0;
            assertEquals('strip', XMLUtil.stripBytes(originBytes), 'aaa bbb');
        }
    }
}
