Radium.SettingsCustomFieldsRoute = Radium.Route.extend
  model: ->
    Ember.A([
      Radium.CustomField.createRecord(type: 'text')
    ])

  deactivate: ->
    controller = @controller

    all = Radium.CustomField.all().toArray()

    for i in [all.get('length') - 1..0] by -1
      customField = all[i]

      controller.get('model').removeObject customField

      if customField.get('isNew')
        customField.unloadRecord()
      else
        customField.reset() if customField.get('isDirty')
