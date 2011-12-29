define('tests/spec/mixins/jqueryui.spec', function(require) {
  require('jquery');
  require('jqueryUI');
  require('ember');
  require('mixins/jqueryui');

  describe("Mixin#jQueryUI", function() {
    
    it("creates a JQ Namespace", function() {
      expect(JQ.Widget).toBeDefined();
    });
    
  });
  
});