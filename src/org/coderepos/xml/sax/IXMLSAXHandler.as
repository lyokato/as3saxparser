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

    public interface IXMLSAXHandler
    {
        function startDocument():void;
        function endDocument():void;
        function startElement(ns:String, localName:String, attributes:XMLAttributes, depth:uint):void;
        function endElement(ns:String, localName:String, depth:uint):void;
        function characters(str:String):void;
        function cdata(str:String):void;
        function comment(str:String):void;
    }
}

