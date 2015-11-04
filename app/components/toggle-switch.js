import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

export default Component.extend({
  classNames: ['toggle-switch'],

  dataOn: "On",
  dataOff: "Off",

  init() {
    this._super(...arguments);

    this.on('change', this, this._updateElementValue);
  },

  willDestroyElement() {
    this._super(...arguments);

    this.off('change');
  },

  checkBoxId: computed(function(){
    return `checker-${this.get('elementId')}`;
  }),

  _updateElementValue() {
    const parentContext = this.get('parentContext');

    if(parentContext) {
      parentContext.send('action', this.get('model'));
    } else {
      this.sendAction();
    }

    if(this.get('dontPropagate')) {
      return;
    }

    this.set('checked', this.$('input').prop('checked'));
  }
});
