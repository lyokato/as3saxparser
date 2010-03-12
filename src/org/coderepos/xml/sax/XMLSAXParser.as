/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package org.coderepos.xml.sax
{
    import flash.utils.ByteArray;

    public class XMLSAXParser
    {
        private var _splitter:XMLFragmentSplitter;
        private var _internalParser:XMLSAXInternalParser;

        public function XMLSAXParser(config:XMLSAXParserConfig=null)
        {
            if (config == null)
                config = new XMLSAXParserConfig();

            _splitter       = new XMLFragmentSplitter(config);
            _internalParser = new XMLSAXInternalParser(config);
        }

        public function set handler(handler:IXMLSAXHandler):void
        {
            _internalParser.handler = handler;
        }

        // @throws XMLSyntaxError, XMLFragmentSizeOverError,
        // XMLElementDepthOverError
        public function pushBytes(bytes:ByteArray):void
        {
            _splitter.pushBytes(bytes);
            var fragment:String;
            while ((fragment = _splitter.splitFragment()) != null) {
                if (fragment.match(/^<\?xml\s.*\?>$/) != null)
                    reset();
                if (fragment.match(/^[ \f\t\r\n\v]*\z/) == null)
                    _internalParser.parseChunk(fragment);
            }
            _splitter.discardRead();
        }

        public function reset():void
        {
            _internalParser.reset();
        }
    }
}

