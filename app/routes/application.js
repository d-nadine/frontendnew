import Ember from 'ember';
import ENV from 'radium/config/environment';

const {
  Route,
  run,
  inject
} = Ember;

export default Route.extend({
  actions: {
    flashMessage(options = {}) {
      console.log(options);
    },

    flashSuccess(message) {
      this.send('flashMessage', {
        type: 'alert-success',
        message: message
      });
    },

    flashError(error) {
      this.send('flashError', {
        type: 'alert-error',
        message: error
      });
    }
  },

  beforeModel() {
    return this.get('session').setup();
  },

  setupController() {
    if(ENV.environment !== "production" || window.location.pathname !== "/") {
      return;
    }

    run.next(() => {
      this.router.replaceWith('addressbook.people.contacts');
    });
  },

  session: inject.service()
});
