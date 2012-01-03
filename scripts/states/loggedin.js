define(function(require) {
    
  var topBar = require('views/topbar').create(),
      _dashboard = require('states/dashboard');
  
  return Ember.StateManager.create({
    enter: function() {
      console.log('logged in');
      $('#main-nav').show();
      topBar.appendTo('#topbar');
    },
    exit: function() {
      console.log('exiting');
      buttonView.destroy();
    },
    dashboard: _dashboard,
    contacts: Ember.State.create({
    }),
    pipeline: Ember.State.create({
    }),
    campaigns: Ember.State.create({
    }),
    calendar: Ember.State.create({
    }),
    messages: Ember.State.create({
    }),
    settings: Ember.State.create({
    })
  });
  
});