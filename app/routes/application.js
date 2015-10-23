import Ember from 'ember';
import ENV from 'radium/config/environment';

const {
  Route,
  run,
  inject
} = Ember;

export default Route.extend({
  beforeModel() {
    return this.get('session').setup();
  },

  setupController() {
    this.get('users').refresh();

    this.get('listsService').refresh();

    if(ENV.environment !== "production" || window.location.pathname !== "/") {
      return;
    }

    run.next(() => {
      this.router.replaceWith('addressbook.people.contacts');
    });
  },

  session: inject.service(),
  users: inject.service(),
  listsService: inject.service()
});
