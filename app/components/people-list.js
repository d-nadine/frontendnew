import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  actions: {
    itemAction(person) {
      if(!this.attrs.itemAction) {
        return;
      }

      this.attrs.itemAction(person);
    }
  },
  tagName: 'span'
});
