import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  relevantMedia: Ember.A(['twitter', 'facebook', 'googleplus', 'linkedin'])
});