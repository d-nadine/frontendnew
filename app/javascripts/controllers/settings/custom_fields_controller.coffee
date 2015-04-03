Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  actions:
    createCustomField: (customField) ->
      p customField

    addNewCustomField: ->
      @get('customFields').addObject type: 'Text'

    removeCustomField: (customField) ->
      @get('customFields').removeObject customField

  customFields: Ember.A([
    {
      type: 'Text'
    }
  ])

  lastItem: Ember.computed.oneWay 'customFields.lastObject'
