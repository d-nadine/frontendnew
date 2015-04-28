Radium.TemplatesNewController = Radium.Controller.extend
  actions:
    saveTemplate: (form) ->
      form.set 'isSubmitted', true

      return unless form.get('isValid')

      template = Radium.Template.createRecord form.get('data')

      form.setFilesOnModel(template)

      template.save(this).then (result) =>
        form.set 'isSubmitted', false
        form.reset()

        @send 'flashSuccess', "Template saved!"

        @get('messagesSidebar').send('showMore')

        @transitionToRoute "templates.edit", result

  needs: ['messagesSidebar']

  messagesSidebar: Ember.computed.oneWay 'controllers.messagesSidebar'
