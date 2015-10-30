import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  actions: {
    sort: function() {
      this.toggleProperty('ascending');
      this.sendAction('sort', this.get('sortOn'), this.get('ascending'));
      return false;
    }
  },

  ascending: true,

  _setup: Ember.on('didInsertElement', function() {
    this._super(...arguments);

    if (this.get('initialDesc')) {
      return this.set('ascending', false);
    } else {
      return this.set('ascending', true);
    }
  })
});