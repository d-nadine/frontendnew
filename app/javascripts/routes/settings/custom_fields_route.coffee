Radium.SettingsCustomFieldsRoute = Radium.Route.extend
  model: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.CustomField.find({}).then((fields) ->
        arr = Ember.A(fields.toArray())

        arr.pushObject(Ember.Object.create(isNew: true, type: 'text'))

        resolve arr
      ).catch((result) ->
        reject(result))

  deactivate: ->
    controller = @controller

    all = Radium.CustomField.all().toArray()

    for i in [all.get('length') - 1..0] by -1
      customField = all[i]

      controller.get('model').removeObject customField

      unless customField.get('isNew')
        customField.reset() if customField.get('isDirty')
