Radium.SaveTemplateMixin = Ember.Mixin.create
  actions:
    saveTemplate: (form) ->
      if !form.get('subject.length') || !form.get('html.length')
        return @send 'flashError', 'You must supply a subject line and an email body for an email template.'

      unless template = @get('template')
        template = Radium.Template.createRecord()

      template.setProperties
                  subject: form.get('subject')
                  html: form.get('html')

      template.save().then (result) =>
        @send 'flashSuccess', "Template Saved"
        @set 'template', result
        @templatesService.get('templates').pushObject(result)
        @templatesService.notifyPropertyChange 'templates'

      false
