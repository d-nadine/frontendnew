Radium.TextFieldFocusMixin = Ember.Mixin.create
  focusIn: () ->
      @get('parentView').set('isFocused', true)

  focusOut: () ->
    @get('parentView').set('isFocused', false)