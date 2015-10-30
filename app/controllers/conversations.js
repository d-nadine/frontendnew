import Ember from 'ember';

const {
  Controller
} = Ember;

export default Controller.extend({
  actions: {
    showUserRecords(user, query) {
      this.transitionTo('conversations', query, {queryParams: {user: user.get('id')}});
    }
  },
  queryParams: ['user'],
  user: null
});
