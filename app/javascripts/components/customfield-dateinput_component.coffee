require 'mixins/customfield_inputmixin'

Radium.CustomfieldDateinputComponent = Ember.Component.extend Radium.CustomFieldInputMixin,
  actions:
    setValue: (date) ->
      @set 'customFieldValue.value', date.toISO8601()

      # FIXME: bind the action and not be explicit
      targetObject = @get('targetObject')

      if @get('targetObject').get('_actions.save')
        targetObject.send 'save'

      false

    dateCleared: ->
      @set('customFieldValue.value', '')

      false

  interenalDate: null

  afterSetup: ->
    unless value = this.get('customFieldValue.value')
      return

    Ember.run.next =>
      return if @isDestroyed || @isDestroying

      @set 'internalDate', Ember.DateTime.parse(value)
