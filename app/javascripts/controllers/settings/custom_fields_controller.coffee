Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  actions:
    createCustomField: (customField) ->
      p customField

    addNewCustomField: ->
      customField = Radium.CustomField.createRecord type: 'Text'
      @get('model').addObject customField

    removeCustomField: (customField) ->
      if customField.get('isNew')
        @get('model').removeObject customField
        return customField.unloadRecord()

  lastItem: Ember.computed.oneWay 'model.lastObject'
