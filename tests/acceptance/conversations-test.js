import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'radium/tests/helpers/start-app';

module('Acceptance | conversations', {
  beforeEach: function() {
    this.application = startApp();
  },

  afterEach: function() {
    Ember.run(this.application, 'destroy');
  }
});

test('visiting /conversations', function(assert) {
  visit('/conversations/incoming');

  andThen(function() {
    assert.equal(currentURL(), '/conversations');
  });
});
