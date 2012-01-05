define(function(require) {
  
  require('ember');

  var loginPane = require('views/loginpane').create();
  
  return Ember.ViewState.create({
    view: loginPane,
    enter: function(manager) {
      manager.set('isLoggedin', NO);
      this._super(manager);
    }
  });
  
});