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
    import com.adobe.utils.StringUtil;
    import org.coderepos.xml.XMLUtil;
    import org.coderepos.xml.XMLElementNS;
    import org.coderepos.xml.XMLAttributes;
    import org.coderepos.xml.exceptions.XMLSyntaxError;
    import org.coderepos.xml.exceptions.XMLElementDepthOverError;

    public class XMLSAXInternalParser
    {
        private var _handler:IXMLSAXHandler;
        private var _currentNS:XMLElementNS;
        private var _completedDecl:Boolean;
        private var _elementStack:Array;

        private var _MAX_ELEMENT_DEPTH:int;

        public function XMLSAXInternalParser(config:XMLSAXParserConfig)
        {
            _completedDecl = false;
            _elementStack = [];
            _currentNS = new XMLElementNS(null, null);
            _currentNS.addNamespace("xml", "http://www.w3.org/XML/1998/namespace");
            _MAX_ELEMENT_DEPTH = config.MAX_ELEMENT_DEPTH;
        }

        public function reset():void
        {
            _completedDecl = false;
            _elementStack  = [];
            _currentNS = new XMLElementNS(null, null);
            _currentNS.addNamespace("xml", "http://www.w3.org/XML/1998/namespace");
        }

        private function getHandler():IXMLSAXHandler
        {
            // null object pattern
            if (_handler == null)
                _handler = new XMLSAXDefaultHandler();
            return _handler;
        }

        public function set handler(newHandler:IXMLSAXHandler):void
        {
            _handler = newHandler;
        }

        public function parseChunk(chunk:String):void
        {
            var ctx:XMLSAXInternalParserContext =
                new XMLSAXInternalParserContext(chunk);

            if (ctx.getAt(0) == XMLUtil.TAG_START) {
                if (_completedDecl) {
                    parseTag(ctx);
                } else {
                    if (ctx.getAt(1) == "?") {
                        parseDecl(ctx);
                        _completedDecl = true;
                        getHandler().startDocument();
                    } else {
                        _completedDecl = true;
                        getHandler().startDocument();
                        parseTag(ctx);
                    }
                }
            } else {
                if (!(_completedDecl && _elementStack.length > 0))
                    throw new XMLSyntaxError(
                        "First text shuld be after decl and under some element: " + chunk);
                parseContent(ctx);
            }
        }

        private function parseTag(ctx:XMLSAXInternalParserContext):void
        {
            switch (ctx.getAt(1)) {
                case '?': parsePI(ctx); break;
                case '!':
                    switch (ctx.getAt(2)) {
                        case 'D': parseDTD(ctx);     break;
                        case '[': parseCDATA(ctx);   break;
                        case '-': parseComment(ctx); break;
                        default:
                            throw new XMLSyntaxError("Invalid tag: " + ctx.chunk);
                    }
                    break;
                case '/': parseEndElement(ctx); break;
                default:  parseElement(ctx);    break;
            }
        }

        private function xName(ctx:XMLSAXInternalParserContext):String
        {
            var ch:String = ctx.get();
            var qname:String = "";
            if (XMLUtil.isNameStart(ch)) {
                qname = ch;
                ch = ctx.next();
                while (XMLUtil.isNameChar(ch)) {
                    qname += ch;
                    ch = ctx.next();
                }
            } else {
                throw new XMLSyntaxError(
                    "element-name or attribute-name is invalid." + ctx.chunk);
            }
            return qname;
        }

        private function xChar(ctx:XMLSAXInternalParserContext, char:String):void
        {
            var ch:String = ctx.get();
            if (ch == char) {
                ctx.next();
            } else {
                throw new XMLSyntaxError(
                    "Expected [" + char + "], but found [" + ch + "]");
            }
        }

        private function xToken(ctx:XMLSAXInternalParserContext,
            token:String):void
        {
            var len:int = token.length;
            for (var i:int = 0; i < len; i++)
                xChar(ctx, token.charAt(i));
        }

        private function xSpace(ctx:XMLSAXInternalParserContext):void
        {
            var ch:String = ctx.get();
            if (XMLUtil.isSpace(ch)) {
                ctx.next();
                xSpaceOpt(ctx);
            } else {
                throw new XMLSyntaxError("whitespace expected: " + ctx.chunk);
            }
        }

        private function xSpaceOpt(ctx:XMLSAXInternalParserContext):void
        {
            var ch:String = ctx.get();
            while (XMLUtil.isSpace(ch))
                ch = ctx.next();
        }

        private function xEQ(ctx:XMLSAXInternalParserContext):void
        {
            xSpaceOpt(ctx);
            xChar(ctx, '=');
            xSpaceOpt(ctx);
        }

        private function xAttributeValue(ctx:XMLSAXInternalParserContext):String
        {
            var delim:String = ctx.get();
            if (delim != "'" && delim != '"')
                throw new XMLSyntaxError("Invalid attribute value: " + ctx.chunk);

            var value:String = "";
            var ch:String = ctx.next();
            while (ch != delim) {
                // XXX: check value? if (ch.match())
                value += ch;
                ch = ctx.next();
            }
            ctx.next();
            return value;
        }

        private function xAttributes(ctx:XMLSAXInternalParserContext):XMLAttributes
        {

            var xmlns:String;
            var namespaces:Object = {};
            var attributes:Array = [];

            var ch:String = ctx.get();
            while (XMLUtil.isNameStart(ch)) {

                var qname:String = xName(ctx);
                xEQ(ctx);
                var value:String = xAttributeValue(ctx);

                var i:int = qname.indexOf(':');
                if (i != -1) {

                    if (i == 0 || i > qname.length - 2)
                        throw new XMLSyntaxError(
                            "Invalid attribute name: " + qname);

                    var prefix:String = qname.substring(0, i);
                    var name:String   = qname.substring(i + 1);

                    if (prefix == "xmlns")
                        namespaces[name] = value;
                    else
                        attributes.push([prefix, name, value]);
                } else {
                    if (qname == "xmlns")
                        xmlns = value;
                    else
                        attributes.push([null, qname, value]);
                }

                ch = ctx.get();
                if ((ch != '>') && (ch != '/') && (ch != '?')) {
                    if (XMLUtil.isSpace(ch)) {
                        ctx.next();
                        xSpaceOpt(ctx);
                    }
                }
                ch = ctx.get();
            }

            // if xmlns is not found on root element, set dummy
            if (_elementStack.length == 0 && xmlns == null)
                xmlns = XMLUtil.DUMMY_NS;

            _currentNS = new XMLElementNS(xmlns, _currentNS);
            for (var pre:String in namespaces)
                _currentNS.addNamespace(pre, namespaces[pre]);

            var attrs:XMLAttributes = new XMLAttributes(_currentNS);
            try {
                for each(var a:Array in attributes)
                    attrs.addAttribute(a[0], a[1], a[2]);
            } catch (e:*) {
                throw new XMLSyntaxError("Invalid attributes: " + ctx.chunk
                    + "\n" + attrs.toString());
            }
            return attrs;
        }

        private function parseElement(ctx:XMLSAXInternalParserContext):void
        {
            ctx.pos = 1;
            var qname:String = xName(ctx);
            xSpaceOpt(ctx);
            var attrs:XMLAttributes = xAttributes(ctx)

            var i:int = qname.indexOf(":");
            var prefix:String;
            var localName:String;
            if (i == -1) {
                prefix    = null;
                localName = qname;
            } else {
                if (i == 0 || i > qname.length - 2)
                    throw new XMLSyntaxError(
                        "Invalid element name: " + qname);
                prefix    = qname.substring(0, i);
                localName = qname.substring(i + 1);
            }

            var ch:String = ctx.get();
            var uri:String = _currentNS.getURIForPrefix(prefix);

            if (_elementStack.length >= _MAX_ELEMENT_DEPTH)
                throw new XMLElementDepthOverError("The Depth is over " + _MAX_ELEMENT_DEPTH);

            if (uri == XMLUtil.DUMMY_NS)
                uri = null;

            if (ch == "/") {
                xToken(ctx, "/>");
                getHandler().startElement(uri, localName, attrs, _elementStack.length);
                _currentNS = _currentNS.getParent();
                getHandler().endElement(uri, localName, _elementStack.length);
            } else {
                getHandler().startElement(uri, localName, attrs, _elementStack.length);
                _elementStack.push([prefix, localName]);
            }

        }

        private function parseEndElement(ctx:XMLSAXInternalParserContext):void
        {
            if (_elementStack.length == 0)
                throw new XMLSyntaxError("Closing tag that doesn't have starting tag: " + ctx.chunk);

            ctx.pos = 2;
            var qname:String = xName(ctx);
            xSpaceOpt(ctx);
            xChar(ctx, ">");

            var i:int = qname.indexOf(":");
            var prefix:String;
            var localName:String;
            if (i == -1) {
                prefix    = null;
                localName = qname;
            } else {
                if (i == 0 || i > qname.length - 2)
                    throw new XMLSyntaxError(
                        "Invalid element name: " + qname);
                prefix    = qname.substring(0, i);
                localName = qname.substring(i + 1);
            }

            var lastElem:Array = _elementStack.pop();
            if (!(prefix == lastElem[0] && localName == lastElem[1]))
                throw new XMLSyntaxError("Unmatched closing tag: " + ctx.chunk
                    + " should be </" + lastElem[1] + ">");

            var uri:String = _currentNS.getURIForPrefix(prefix);
            if (uri == XMLUtil.DUMMY_NS)
                uri = null;

            _currentNS = _currentNS.getParent();

            getHandler().endElement(uri, localName, _elementStack.length);

            if (_elementStack.length == 0) {
                getHandler().endDocument();
                reset();
            }
        }

        private function parseContent(ctx:XMLSAXInternalParserContext):void
        {
            if (_elementStack.length == 0)
                throw new XMLSyntaxError(
                    "Text shuld be after decl and under some element: " + ctx.chunk);

            var content:String = StringUtil.trim(ctx.chunk);
            if (content.length > 0)
                getHandler().characters(XMLUtil.unescapeXMLChar(content));
        }

        private function parseDecl(ctx:XMLSAXInternalParserContext):void
        {
            // not implemented yet.
        }

        private function parsePI(ctx:XMLSAXInternalParserContext):void
        {
            // not implemented yet.
        }

        private function parseDTD(ctx:XMLSAXInternalParserContext):void
        {
            // not implemented yet.
        }

        private function parseCDATA(ctx:XMLSAXInternalParserContext):void
        {
            if (_elementStack.length == 0)
                throw new XMLSyntaxError("Invalid tag for CDATA: " + ctx.chunk);

            var res:Array = ctx.chunk.match(/\A\<\!\[CDATA\[((?:.|\n)+)\]\]\>\z/);
            if (res == null)
                throw new XMLSyntaxError("Invalid tag for CDATA: " + ctx.chunk);

            var cdata:String = StringUtil.trim(res[1]);
            if (cdata.length > 0)
                getHandler().cdata(cdata);
        }

        private function parseComment(ctx:XMLSAXInternalParserContext):void
        {
            var res:Array = ctx.chunk.match(/^\<\!\-\-((?:.|\n)+)\-\-\>\z/);
            if (res == null)
                throw new XMLSyntaxError("Invalid tag for comment: " + ctx.chunk);

            var comment:String = StringUtil.trim(res[1]);
            if (comment.length > 0)
                getHandler().comment(comment);
        }

    }
}

