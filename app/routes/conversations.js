import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    user: {
      refreshModel: true
    }
  }
});
