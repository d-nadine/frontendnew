require 'lib/radium/multiple_field'

Radium.MaskedMultipleField = Radium.MultipleField.extend
  didInsertElement: ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, =>
      input = @$('input')
      val = @get('source')[@get('index')].value
      input.val(val)
      input.mask(@get("parentView.mask"), allow: true)


