define('testdir/mixins/jqueryui.spec', function(require) {
  
  require('ember');
  var Radium = require('radium');
  
  describe("Mixin#jQueryUI", function() {
    
    it("creates a JQ Namespace", function() {
      expect(JQ.Widget).toBeDefined();
    });
        
  });
  
});