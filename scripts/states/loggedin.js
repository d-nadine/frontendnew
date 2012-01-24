define(function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('views/topbar');
    
  var topBarView = Radium.TopbarView.create(),
      dashboardState = require('states/dashboard');
  
  return Ember.StateManager.create({
    rootElement: '#main',
    enter: function() {
      $('#main-nav').show();
      topBarView.appendTo('#topbar');
    },
    exit: function() {
      topBarView.remove();
    },
    dashboard: dashboardState.create(),
    contacts: Ember.State.create({}),
    pipeline: Ember.State.create({}),
    campaigns: Ember.State.create({}),
    calendar: Ember.State.create({}),
    messages: Ember.State.create({}),
    settings: Ember.State.create({})
  });
  
  return Radium;
});