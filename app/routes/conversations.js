import Ember from 'ember';

const {
  Route
} = Ember;

export default Route.extend({
  queryParams: {
    user: {
      refreshModel: true
    }
  }
});
