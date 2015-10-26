import Ember from 'ember';

const {
  Component,
  computed,
  run
} = Ember;

export default Component.extend({
 click(event) {
   event.stopPropagation();
   return run.schedule('actions', this, 'sendNotification');
 },

  sendNotification() {
    this.sendAction('action');
    return false;
  },

  init: function() {
    this._super(...arguments);
    return this.on("change", this, this._updateElementValue);
  },

  setup: Ember.on('didInsertElement', function() {
    this._super(...arguments);
    return this.$('input').prop('checked', !!this.get('checked'));
  }),

  teardown: Ember.on('willDestroyElement', function() {
    this._super(...arguments);

    return this.off("change");
  }),

  _updateElementValue() {
    this.set('checked', this.$('input').prop('checked'));
    return false;
  },

  checkBoxId: computed(function() {
    return "checker-" + (this.get('elementId'));
  })
});
