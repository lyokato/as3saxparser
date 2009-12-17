package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.XMLElementBuffer;
    import org.coderepos.xml.XMLElement;
    import org.coderepos.xml.XMLElementNS;
    import org.coderepos.xml.XMLAttributes;

    import flash.utils.ByteArray;

    public class XMLElementBufferTest extends TestCase
    {
        public function XMLElementBufferTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLElementBufferTest("testBuffer") );
            return ts;
        }

        public function testBuffer():void
        {
            var atomNSURI:String = "http://www.w3.org/2005/Atom";
            var appNSURI:String = "http://www.w3.org/2007/app"

            var topNS:XMLElementNS = new XMLElementNS(null, null);
            topNS.addNamespace("xml", "http://www.w3.org/1998/xml/namespace");
            var atomNS:XMLElementNS  = new XMLElementNS(atomNSURI, topNS);
            var emptyNS:XMLElementNS = new XMLElementNS(null, atomNS);
            var appNS:XMLElementNS   = new XMLElementNS(appNSURI, atomNS);

            var entryAttr:XMLAttributes   = new XMLAttributes(atomNS);
            var titleAttr:XMLAttributes   = new XMLAttributes(emptyNS);
            var controlAttr:XMLAttributes = new XMLAttributes(appNS);

            var buf:XMLElementBuffer = new XMLElementBuffer(atomNSURI, "entry", entryAttr, 0);

            assertTrue(buf.match(atomNSURI, "entry", 0));
            assertFalse(buf.match(atomNSURI, "feed", 0));


            // to check child
            buf.startCapturingDescendant(atomNSURI, "title", titleAttr, 1);

            assertTrue(buf.isCapturingDescendant(atomNSURI, "title", 1));
            assertFalse(buf.isCapturingDescendant(atomNSURI, "id", 1));

            buf.pushText("My Title");
            buf.finishCapturingDescendant(atomNSURI, "title", 1);


            // to check diffrent ns child
            buf.startCapturingDescendant(appNSURI, "control", controlAttr, 1);
            buf.pushText("hoge");
            buf.finishCapturingDescendant(appNSURI, "control", 1);

            var entry:XMLElement =  buf.toElement();
            assertEquals("entry.ns", "http://www.w3.org/2005/Atom", entry.ns);
            assertEquals("entry.localName", "entry", entry.localName);

            var id:XMLElement = entry.getFirstElement("id");
            assertNull(id);

            var title:XMLElement = entry.getFirstElement("title");
            assertNotNull(title);

            assertEquals("title.ns", "http://www.w3.org/2005/Atom", title.ns);
            assertEquals("title.localName", "title", title.localName);
            assertEquals("title.text", "My Title", title.text);

            var controlWithoutNS:XMLElement = entry.getFirstElement("control");
            assertNull(controlWithoutNS);

            var control:XMLElement = entry.getFirstElementNS("http://www.w3.org/2007/app", "control");
            assertNotNull(control);
            assertEquals("control.text", "hoge", control.text);
        }
    }
}

