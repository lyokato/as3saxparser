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

package org.coderepos.xml
{
    public class XMLAttribute
    {
        private var _uri:String;
        private var _name:String;
        private var _value:String;

        public function XMLAttribute(uri:String, name:String, value:String)
        {
            _uri   = uri;
            _name  = name;
            _value = value;
        }

        public function get uri():String
        {
            return _uri;
        }

        public function get name():String
        {
            return _name;
        }

        public function get value():String
        {
            return _value;
        }
    }
}

