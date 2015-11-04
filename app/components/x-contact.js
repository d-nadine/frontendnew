import Ember from 'ember';
import SpreadArgs from 'radium/mixins/spread-args-mixin';

const {
  Component
} = Ember;

export default Component.extend(SpreadArgs, {
  actions: {
    deleteContact(contact) {
      this.sendAction("deleteContact", contact);

      this.EventBus.publish("closeDrawers");

      return false;
    }
  },

  classNames: ['two-column-layout'],

  showDeleteConfirmation: false,

  _initialize: Ember.on('init', function() {
    this._super(...arguments);

    //FIXME: add polling logic for existing contacts
  })
});