package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.xml.sax.XMLElementEventHandler;
    import org.coderepos.xml.sax.XMLSAXParser;
    import org.coderepos.xml.XMLElement;
    import org.coderepos.xml.XMLAttributes;

    import flash.utils.ByteArray;

    public class XMLElementEventHandlerTest extends TestCase
    {
        private var _calledAttrEvent:Boolean = false;
        private var _calledMessageEvent:Boolean = false;
        private var _calledPresenceEvent:Boolean = false;
        private var _calledIQEvent:Boolean = false;

        public function XMLElementEventHandlerTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest( new XMLElementEventHandlerTest("testParse") );
            return ts;
        }

        private function genHandler():XMLElementEventHandler
        {
            var handler:XMLElementEventHandler = new XMLElementEventHandler();
            handler.registerRootElementAttributeEvent("http://etherx.jabber.org/stream", "stream", attrEvent);
            handler.registerElementEvent("jabber:client", "presence", 1, presenceEvent);
            handler.registerElementEvent("jabber:client", "message", 1, messageEvent);
            handler.registerElementEvent("jabber:client", "iq", 1, iqEvent);
            return handler;
        }

        private function attrEvent(attr:XMLAttributes):void
        {
            _calledAttrEvent = true;
            assertEquals("attr.getValue('from')", "wonderland.lit", attr.getValue("from"));
            assertEquals("attr.getValue('id')", "foobar", attr.getValue("id"));
            assertEquals("attr.getValue('version')", "1.0", attr.getValue("version"));
        }

        private function messageEvent(elem:XMLElement):void
        {
            _calledMessageEvent = true;
            assertEquals("message:elem.ns", "jabber:client", elem.ns);
            assertEquals("message:elem.localName", "message", elem.localName);

            assertEquals("message@from", "queen@wonderland.lit", elem.getAttr("from"));
            assertEquals("message@to", "madhatter@wonderland.lit", elem.getAttr("to"));
            assertNull("unknown attribute should be null", elem.getAttr("unknown"));

            var body:XMLElement = elem.getFirstElement("body");
            assertEquals("body.text", "Off with his head!", body.text);
        }

        private function presenceEvent(elem:XMLElement):void
        {
            _calledPresenceEvent = true;
            assertEquals("presence:elem.ns", "jabber:client", elem.ns);
            assertEquals("presence:elem.localName", "presence", elem.localName);

            assertEquals("presence@type", "unavailable", elem.getAttr("type"));
        }

        private function iqEvent(elem:XMLElement):void
        {
            _calledIQEvent = true;
            assertEquals("iq:elem.ns", "jabber:client", elem.ns);
            assertEquals("iq:elem.localName", "iq", elem.localName);

            var query:XMLElement = elem.getFirstElementNS("jabber:iq:roster", "query");
            assertNotNull(query);

            var items:Array = query.getElements("item");
            assertEquals("iq/query/item length", 3, items.length);
            assertEquals("item[0]@jid", "alice@wonderland.lit", items[0].getAttr("jid"));
            assertEquals("item[1]@jid", "madhatter@wonderland.lit", items[1].getAttr("jid"));
            assertEquals("item[2]@jid", "whiterabbit@wonderland.lit", items[2].getAttr("jid"));
        }

        private function genBytesFromString(str:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(str);
            return b;
        }

        public function testParse():void
        {
            var parser:XMLSAXParser = new XMLSAXParser();
            parser.handler = genHandler();
            parser.pushBytes(genBytesFromString("<stream:stream from='wonderland.lit' id='foobar' version='1.0' xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/stream'>"
            + "<iq type='result'><query xmlns='jabber:iq:roster'><item jid='alice@wonderland.lit'/><item jid='madhatter@wonderland.lit'/><item jid='whiterabbit@wonderland.lit'/></query></iq>"
            + "<message from='queen@wonderland.lit' to='madhatter@wonderland.lit'><body>Off with his head!</body></message>"
            + "<presence type='unavailable'/>"
            + "</stream:stream>"));
            assertTrue(_calledAttrEvent);
            assertTrue(_calledMessageEvent);
            assertTrue(_calledPresenceEvent);
            assertTrue(_calledIQEvent);
        }
    }
}

