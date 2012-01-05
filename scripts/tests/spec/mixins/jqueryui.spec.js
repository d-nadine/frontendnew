define('testdir/mixins/jqueryui.spec', function(require) {

  describe("Mixin#jQueryUI", function() {
    
    it("creates a JQ Namespace", function() {
      expect(JQ.Widget).toBeDefined();
    });
        
  });
  
});