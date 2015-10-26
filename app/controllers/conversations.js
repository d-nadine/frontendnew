import Ember from 'ember';
import ColumnsConfig from 'radium/mixins/conversations-columns-config';

const {
  Controller
} = Ember;

export default Controller.extend(ColumnsConfig, {
  actions: {
    showUserRecords(user, query) {
      this.transitionTo('conversations', query, {queryParams: {user: user.get('id')}});
    }
  },
  queryParams: ['user']
});
