define(function(require) {
  require('controllers/app');
  var get = Ember.get,
      buttonView = require('views/button').create(),
      asdf = Ember.View.create({template: Ember.Handlebars.compile('hi')});
  
  Radium.App = Ember.StateManager.create({
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
        console.log('entering logginIn')
        transition.async();
        transition.resume();
        manager.goToState('loggedIn');
      },
      exit: function(manager, transition) {
        console.log('leaving .loggingIn');
      }
    }),
    loggedIn: Ember.State.create({
      enter: function() {
        console.log('logged in');
      },
      exit: function() {
        console.log('logging out');
      }
    }),
    logIn: function() {
      this.goToState('loggedIn');
    }
    // loggedIn: Ember.StateManager.create({
    //   initialState: 'dashboard',
    //   enter: function() {
    //     console.log('logged in');
    //     buttonView.appendTo('#action-button-container');
    //   },
    //   exit: function() {
    //     console.log('exiting');
    //     buttonView.destroy();
    //   },
    //   dashboard: Ember.State.create({
    //     enter: function() {
    //       Radium.appController.set('currentSection', 'dashboard');
    //     },
    //     test: Ember.StateManager.create({
    //       rootElement: '#feed',
    //       start: Ember.ViewState.create({view: asdf})
    //     })
    //   }),
    //   contacts: Ember.State.create({
    //     enter: function() {
    //       Radium.appController.set('currentSection', 'contacts');
    //     }
    //   }),
    //   pipeline: Ember.State.create({
    //     enter: function() {
    //       Radium.appController.set('currentSection', 'pipeline');
    //     }
    //   }),
    //   messages: Ember.State.create({
    //     enter: function() {
    //       Radium.appController.set('currentSection', 'messages');
    //     }
    //   })
    // })
  });
    
});