package suite {
  
  import flexunit.framework.TestSuite;  
  
  public class AllTests extends TestSuite {
    
    public function AllTests() {
      super();
      // Add tests here
      // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
      addTest(XMLUtilTest.suite());
      addTest(XMLFragmentSplitterTest.suite());
      addTest(XMLElementNSTest.suite());
      addTest(XMLSAXInternalParserTest.suite());
      addTest(XMLSAXInternalParserTest2.suite());
      addTest(XMLSAXParserTest.suite());
    }
    
  }
  
}
