Radium.TemplatesFieldsPromise = Ember.Mixin.create
  templatesFiledsPromise: (controllerName) ->

    self = this
    new Ember.RSVP.Promise (resolve, reject) ->
      Ember.RSVP.hash(
        customFields: Radium.CustomField.find({})
        templates: Radium.Template.find({})
      ).then((hash) ->
        controller = self.controllerFor(controllerName)
        controller.set('customFields', hash.customFields)
        controller.set('templates', hash.templates)
        resolve()
      ).catch (error) ->
        Ember.Logger.error error
        reject(error)
