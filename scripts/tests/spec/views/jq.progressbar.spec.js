define('tests/spec/views/jq.progressbar.spec', function(require) {
  require('jquery');
  require('jqueryUI');
  require('ember');
  require('mixins/jqueryui');
  
  var view;
  
  describe("ProgressBarView", function() {
    
    it("creates a jQueryUI progress bar", function() {
      var progressbar = require('views/jq.progressbar').create();
      
      Ember.run(function() {
        progressbar.append();
      });
      
      expect(progressbar.$().hasClass('ui-progressbar')).toBeTruthy();
    });
    
  });
      
});