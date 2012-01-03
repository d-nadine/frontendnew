define(function(require) {
  
  require('ember');
  
  var topBar = require('views/topbar').create();
  
  return Ember.StateManager.create({
    initialState: 'dashboard',
    enter: function() {
      console.log('logged in');
      $('#main-nav').show();
      topBar.appendTo('#topbar');
    },
    exit: function() {
      console.log('exiting');
      buttonView.destroy();
    },
    dashboard: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'dashboard');
      }
    }),
    contacts: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'contacts');
      }
    }),
    pipeline: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'pipeline');
      }
    }),
    campaigns: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'campaigns');
      }
    }),
    calendar: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'calendar');
      }
    }),
    messages: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'messages');
      }
    }),
    settings: Ember.State.create({
      enter: function() {
        Radium.appController.set('currentSection', 'settings');
      }
    })
  });
  
});