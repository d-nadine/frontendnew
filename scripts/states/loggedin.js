define(function(require) {
    
  var topBarView = Radium.TopbarView.create(),
      // globalSearchView = require('views/globalsearch').create(),
      _dashboard = require('states/dashboard');
  
  return Ember.StateManager.create({
    rootElement: '#main',
    enter: function() {
      console.log('logged in');
      $('#main-nav').show();
      topBarView.appendTo('#topbar');
    },
    exit: function() {
      console.log('exiting');
    },
    dashboard: Ember.ViewState.create({
      view: Radium.DashboardView.create()
    }),
    contacts: Ember.State.create({}),
    pipeline: Ember.State.create({}),
    campaigns: Ember.State.create({}),
    calendar: Ember.State.create({}),
    messages: Ember.State.create({}),
    settings: Ember.State.create({})
  });
  
});