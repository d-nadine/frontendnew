define('tests/spec/mixins/jqueryui.spec', function(require) {
  require('order!jquery');
  require('order!jqueryUI');
  require('order!ember');
  require('order!mixins/jqueryui');

  describe("Mixin#jQueryUI", function() {
    
    it("creates a JQ Namespace", function() {
      expect(JQ.Widget).toBeDefined();
    });
        
  });
  
});