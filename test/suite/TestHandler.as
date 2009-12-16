package suite {

    import org.coderepos.xml.sax.XMLSAXDefaultHandler;
    import org.coderepos.xml.XMLAttributes;
    import org.coderepos.xml.XMLAttribute;

    public class TestHandler extends XMLSAXDefaultHandler {

        private var _results:Array;
        private var _tc:XMLSAXParserTest2;

        public function TestHandler(tc:XMLSAXParserTest2) 
        {
            _results = [];
            _tc = tc;
        }

        public function get results():Array
        {
            return _results;
        }

        override public function startDocument():void 
        {
            _results.push("startDocument");
        }

        override public function endDocument():void {
            _results.push("endDocument");
            _tc.finish(_results);
        }
        override public function startElement(ns:String, name:String, attr:XMLAttributes, depth:uint):void {
            _results.push("element[" + ns + ":" + name + ":" + String(depth) + "]");
            var arr:Array = attr.toArray();
            for (var i:int=0; i<arr.length;i++) {
                _results.push("ATTR["+arr[i].uri+":"+ arr[i].name + ":" + arr[i].value + "]");
            }
        }
        override public function endElement(ns:String, name:String, depth:uint):void {
            _results.push("endElement[" + ns + ":" + name + ":" + String(depth) + "]");
        }
        override public function characters(s:String):void {
            _results.push("CHARS[" + s + "]");
        }
        override public function cdata(s:String):void {
            _results.push("CDATA[" + s + "]");
        }
        override public function comment(s:String):void { 
            _results.push("COMMENT[" + s + "]") ;
        }

    }

}
