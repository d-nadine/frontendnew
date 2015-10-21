import Ember from 'ember';

const {
  Route
} = Ember;

export default Route.extend({
  model() {
    console.log('in here');
  }
});
