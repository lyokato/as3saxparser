package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.XMLElementNS;

    import flash.utils.ByteArray;

    public class XMLElementNSTest extends TestCase
    {
        public function XMLElementNSTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLElementNSTest("testNS") );
            return ts;
        }

        public function testNS():void
        {
            var top:XMLElementNS = new XMLElementNS("http:/example.org/top", null);

            var child:XMLElementNS = new XMLElementNS("http://example.org/child", top);
            child.addNamespace("hoge", "http://example.org/hoge");
            assertEquals("getURI works correctly", child.getURI(), "http://example.org/child");
            assertEquals("getURIForPrefix works correctly", "http://example.org/hoge", child.getURIForPrefix("hoge"));

            var child2:XMLElementNS = new XMLElementNS(null, child);
            assertEquals("getURIForPrefix correctly picked up parent's.", "http://example.org/hoge", child2.getURIForPrefix("hoge"));
        }

    }
}
