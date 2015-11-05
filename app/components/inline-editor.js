import Ember from 'ember';
import InlineEditorBase from 'radium/mixins/inline-editor-base';

const {
  Component
} = Ember;

export default Component.extend(InlineEditorBase, {
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