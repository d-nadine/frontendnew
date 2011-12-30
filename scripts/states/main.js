define(function(require) {
  require('controllers/app');
  var buttonView = require('views/button').create();
  
  Radium.App = Ember.StateManager.create({
    initialState: 'loggedOut',
    isLoggedIn: YES,
    loggedOut: Ember.State.create({
      enter: function() {
        this.set('isLoggedIn', NO);
        console.log('logged out');
      },
      exit: function() {
        console.log('leaving logged out');
      }
    }),
    loggingIn: Ember.State.create({
      enter: function(manager, transition) {
        console.log('logging in...')
        transition.async();
        transition.resume();
        manager.goToState('loggedIn');
      },
      exit: function(manager, transition) {
        console.log('login successful!');
      }
    }),
    loggedIn: Ember.StateManager.create({
      initialState: 'dashboard',
      enter: function() {
        console.log('logged in');
        buttonView.appendTo('#action-button-container');
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
      messages: Ember.State.create({
        enter: function() {
          Radium.appController.set('currentSection', 'messages');
        }
      })
    })
  });
    
});