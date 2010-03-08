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
    import org.coderepos.xml.XMLAttributes;

    // this class behaves as a null object or an abstract class.
    public class XMLSAXDefaultHandler implements IXMLSAXHandler
    {
        public function XMLSAXDefaultHandler()
        {

        }

        public function startDocument():void
        {
            // do nothing
            // define in subclass
        }

        public function endDocument():void
        {
            // do nothing
            // define in subclass
        }

        public function startElement(ns:String, localName:String, attrs:XMLAttributes, depth:uint):void
        {
            // do nothing
            // define in subclass
        }

        public function endElement(ns:String, localName:String, depth:uint):void
        {
            // do nothing
            // define in subclass
        }

        public function cdata(str:String):void
        {
            // do nothing
            // define in subclass
        }

        public function characters(str:String):void
        {
            // do nothing
            // define in subclass
        }

        public function comment(str:String):void
        {
            // do nothing
            // define in subclass
        }

    }
}

