define('tests/spec/views/jq.progressbar.spec', function(require) {
  require('order!jquery');
  require('order!jqueryUI');
  require('order!ember');
  require('order!mixins/jqueryui');
  
  var view;
  
  describe("ProgressBarView", function() {
    
    it("creates a jQueryUI progress bar", function() {
      var progressbar = require('order!views/jq.progressbar').create();
      
      Ember.run(function() {
        progressbar.append();
      });
      
      expect(progressbar.$().hasClass('ui-progressbar')).toBeTruthy();
    });
    
  });
      
});