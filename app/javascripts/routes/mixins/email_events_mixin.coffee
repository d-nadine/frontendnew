Radium.EmailEventsMixin = Ember.Mixin.create
  events:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      @controllerFor('addressbook').set 'activeForm', null
      @controllerFor('pipelineLeads').set 'activeForm', null

      @controllerFor('emailsSent').set('model', form)

      template = if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

      @render 'emails/sent',
        into: template
        outlet: 'confirmation'

    closeEmailConfirmation: ->
      template = if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

      @render 'nothing',
        into: template
        outlet: 'confirmation'
