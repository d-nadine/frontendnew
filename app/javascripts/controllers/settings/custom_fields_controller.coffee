Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  actions:
    createCustomField: (customField) ->
      isNew = customField.get('isNew')

      if isNew
        newRecord = Radium.CustomField.createRecord(customField.toHash())
        model = @get('model')

        index = model.indexOf customField

        model.removeObject(customField)

        model.insertAt index, newRecord

        customField = newRecord

      customField.save(this).then (result) =>
        @send 'flashSuccess', 'Custom Field Saved.'

      return unless isNew

      @get('model').pushObject(Ember.Object.create(isNew: true, type: 'text'))

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
