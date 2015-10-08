Radium.CustomFieldInputMixin = Ember.Mixin.create Radium.KeyConstantsMixin,
  setup: Ember.on 'didInsertElement', ->
    customFieldValue = @get('customFieldValue')

    Ember.assert "You must supply a customFieldValue", customFieldValue

    value = customFieldValue.get('value') || ''

    @$().val(value)

    Ember.run.scheduleOnce 'afterRender', this, 'afterSetup'

  afterSetup: ->
    # override this for additional functionality
    null
