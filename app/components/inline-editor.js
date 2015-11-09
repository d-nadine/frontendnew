import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  classNameBindings: ['isEditing'],

  focusIn() {
    this._super(...arguments);

    this.set('isEditing', true);
  },

  focusOut() {
    this._super(...arguments);

    this.set('isEditing', false);
  },

  isEditing: false
});
