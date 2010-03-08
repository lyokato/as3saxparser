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
    internal class XMLSAXInternalParserContext
    {
        public var pos:int;
        public var chunk:String;
        private var _length:int;

        public function XMLSAXInternalParserContext(ch:String)
        {
            pos   = 0;
            chunk = ch;
            _length = chunk.length;
        }

        public function get():String
        {
            return chunk.charAt(pos);
        }

        public function getAt(i:int):String
        {
            if (i + 1 >= _length)
                return null;
            return chunk.charAt(i);
        }

        public function next():String
        {
            if (pos + 1 >= _length)
                return null;
            return chunk.charAt(++pos);
        }
    }
}

