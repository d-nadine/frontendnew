require 'lib/radium/multiple_field'

Radium.MaskedMultipleField = Radium.MultipleField.extend
  didInsertElement: ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, =>
      @$('input').mask(@get("parentView.mask"))


