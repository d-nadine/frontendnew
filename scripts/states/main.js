define(function(require) {
  require('ember');
  require('router');
  require('controllers/app');
  
  var buttonView = require('views/button').create(),
      loginPane = require('views/loginpane').create();
  
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
    }),
    
    // Events
    logIn: function() {
      this.goToState('loggingIn');
    },
    
    loadPage: function() {
      console.log(arguments)
      this.goToState('loggedIn.contacts');
    }
  });
  
  
  Radium.Router = Ember.Object.create({
    pages: function(page) {
      if (page.page) {
        Radium.App.goToState('loggedIn.pipeline');
      }
    }
  });
});