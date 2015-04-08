Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  actions:
    createCustomField: (customField) ->
      model = @get('model')

      index = model.indexOf customField

      model.removeObject(customField)

      newRecord = Radium.CustomField.createRecord(customField.toHash())

      newRecord.save(this).then (result) =>
        model.insertAt index, newRecord
        @send 'flashSuccess', 'Custom Field Saved.'

      @get('model').pushObject(Ember.Object.create(isNew: true, type: 'text'))

    updateCustomField: (customField) ->
      customField.save(this).then (result) =>
        @send 'flashSuccess', 'Custom Field Saved.'

    addNewCustomField: ->
      customField = Ember.Object.create isNew: true, type: 'text'
      @get('model').addObject customField

    removeCustomField: (customField) ->
      isNew = customField.get('isNew')

      remove = =>
        @get('model').removeObject customField
        customField.unloadRecord() unless isNew
        @send('flashSuccess', 'field deleted') unless isNew

      return remove() if isNew

      customField.delete(this).then remove

  lastItem: Ember.computed.oneWay 'model.lastObject'

  isSubmitted: false
