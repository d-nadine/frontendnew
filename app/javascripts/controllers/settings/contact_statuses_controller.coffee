Radium.SettingsContactStatusesController = Radium.ArrayController.extend
  actions:
    createContactStatus: ->
      maxId = @get('maxId') || 0

      contactStatus = Radium.ContactStatus.createRecord name: "New Contact Status #{maxId + 1}"

      contactStatus.save(this).then( (result) =>
        @send 'flashSuccess', 'Contact Status created.'
      ).catch (error) ->
        contactStatus.unloadRecord()

  ids: Ember.computed.mapProperty('model', 'id')
  maxId: Ember.computed.max('ids')