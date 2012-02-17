describe("ProgressBarView", function() {
  var view;
  afterEach(function() {
    $('.ui-progressbar').remove();
  });
  
  it("creates a jQueryUI progress bar", function() {
    var progressbar = require('order!views/jq.progressbar').create();
    
    Ember.run(function() {
      progressbar.append();
    });
    
    expect(progressbar.$().hasClass('ui-progressbar')).toBeTruthy();
  });
  
});