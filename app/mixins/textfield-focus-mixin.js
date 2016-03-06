import Ember from 'ember';

Radium.TextFieldFocusMixin = Ember.Mixin.create({
  focusIn: function() {
    return this.get('parentView').set('isFocused', true);
  },
  focusOut: function() {
    return this.get('parentView').set('isFocused', false)
  }
});
