import Ember from 'ember';

const {
  Route
} = Ember;

export default Route.extend({
  beforeModel (transition) {
    console.log(transition);
  }
});
