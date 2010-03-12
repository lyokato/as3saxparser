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
    public class XMLUtil
    {
        public static const TAG_START:String = "<";
        public static const TAG_END:String = ">";
        public static const TAG_START_CHARCODE:int = TAG_START.charCodeAt(0);
        public static const TAG_END_CHARCODE:int = TAG_END.charCodeAt(0);
        public static const RBRA:String = "]";
        public static const RBRA_CHARCODE:int = RBRA.charCodeAt(0);
        public static const HYPHEN:String = "-";
        public static const HYPHEN_CHARCODE:int = HYPHEN.charCodeAt(0);

        public static function isNameStart(char:String):Boolean
        {
            return (char.match(/^[a-zA-Z\_\:]$/) != null);
        }

        public static function isNameChar(char:String):Boolean
        {
            return (char.match(/^[a-zA-Z0-9\.\-\_\:]$/) != null);
        }

        public static function isSpace(char:String):Boolean
        {
            return (char.match(/^[ \f\t\r\n\v]\z/) != null);
        }

        public static function genElementSig(ns:String, localName:String):String
        {
            if (ns == null)
                ns = "http://coderepos.org/ns/null";
            return ns + "$" + localName;
        }

        public static function escapeXMLChar(src:String):String
        {
            return src.replace(/([\<\>\&\'\"])/g, function():String {
                var escaped:String;
                switch (arguments[1]) {
                    case '<':
                        escaped = "&lt;"
                        break;
                    case '>':
                        escaped = "&gt;"
                        break;
                    case '&':
                        escaped = "&amp;"
                        break;
                    case '"':
                        escaped = "&quot;"
                        break;
                    case "'":
                        escaped = "&apos;"
                        break;
                }
                return escaped;
            });
        }

        public static function unescapeXMLChar(src:String):String
        {
            return src.replace(/\&(lt|gt|amp|quot|apos)\;/g, function():String{
                var unescaped:String;
                switch (arguments[1]) {
                    case "lt":
                        unescaped = "<";
                        break;
                    case "gt":
                        unescaped = ">";
                        break;
                    case "amp":
                        unescaped = "&";
                        break;
                    case "quot":
                        unescaped = '"';
                        break;
                    case "apos":
                        unescaped = "'";
                        break;
                }
                return unescaped;
            });
        }

    }
}

