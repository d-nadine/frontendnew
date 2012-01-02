define(function(require) {
  require('ember');
  require('controllers/app');
  
  var loginPane = require('views/loginpane').create(),
      topBar = require('views/topbar').create();
  
  Radium.App = Ember.StateManager.create({
    initialState: 'loggedOut',
    isLoggedIn: NO,
    
    loggedOut: Ember.ViewState.create({
      view: loginPane,
      enter: function() {
        this.get('view').appendTo('#main');
      },
      exit: function() {
        this.get('view').destroy();
      }
    }),
    
    loggingIn: Ember.State.create({
      enter: function(manager, transition) {
        // TODO: Set up form validation logic here.
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
    }),
    
    error: Ember.State.create({
      enter: function() {
        console.log('error');
      }
    }),
    
    // Events
    logIn: function() {
      this.goToState('loggingIn');
    },
    
    loadPage: function() {
      this.goToState('loggedIn.contacts');
    }
  });
  
});