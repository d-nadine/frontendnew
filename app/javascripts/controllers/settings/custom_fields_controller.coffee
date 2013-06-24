Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  newCustomField: null
  isValidCustomField: Em.computed.empty('newCustomField')

  createCustomField: () ->
    newCustomField = @get('newCustomField')
    if newCustomField
      @get('content').pushObject(
        key: @get('newCustomField')
      )

      @set('newCustomField', null)

  removeCustomField: (field) ->
    @get('content').removeObject(field)