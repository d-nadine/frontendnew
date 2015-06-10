Radium.TemplatesEditController = Radium.Controller.extend
  actions:
    saveTemplate: (form) ->
      form.set 'isSubmitted', true

      Ember.assert "a valid template form is required", form.get('id')

      model = @get('model')

      model.setProperties form.get('data')

      return unless model.get('isDirty')

      model.save().then (result) =>
        @send 'flashSuccess', "Template saved!"
