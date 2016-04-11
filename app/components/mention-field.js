import Ember from 'ember';
import TextFieldFocusMixin from 'radium/mixins/textfield-focus-mixin';
import FocusTextareaMixin from 'radium/mixins/textarea-focus-mixin';

export default Ember.TextArea.extend(TextFieldFocusMixin, FocusTextareaMixin, {
  //attributeBindings: ['readonly'],
  classNameBindings: ['disabled:is-disabled', ':mention-field-view'],
  //sourceBinding: 'controller.controllers.users',
  rows: 1,
  tabIndexBinding: 'parentView.tabIndex',
  placeholderBinding: 'parentView.placeholder',
  //readonlyBinding: 'parentView.readonly',
  valueBinding: 'parentView.value',
  keyDown: function(event) {
    if(event.keycode != 13) {
      return;
    }

    this.get('parentView').send('submit');

    event.preventDefault();
  }
});
