import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  classNameBindings: ['item.isChecked:is-checked', 'item.read:read:unread'],
  attributeBindings: ['dataModel:data-model']

});