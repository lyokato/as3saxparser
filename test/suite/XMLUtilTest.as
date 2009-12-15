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
            return ts;
        }

        public function testEscape():void
        {
            var origin:String = "<foo>";
            var escaped:String = XMLUtil.escapeXMLChar(origin);
            assertEquals(escaped, '&lt;foo&gt;');
            var unescaped:String = XMLUtil.unescapeXMLChar(escaped);
            assertEquals(unescaped, '<foo>');
        }

    }
}
