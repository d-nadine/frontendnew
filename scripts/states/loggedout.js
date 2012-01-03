define(function(require) {
  
  require('ember');

  var loginPane = require('views/loginpane').create();
  
  return Ember.ViewState.create({
    view: loginPane,
    enter: function() {
      this.get('view').appendTo('#main');
    },
    exit: function() {
      this.get('view').destroy();
    }
  });
  
});