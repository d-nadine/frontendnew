require 'forms/email_form'

Radium.DevelopmentEmailFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newEmail: Radium.computed.newForm('emailForm')

  emailFormDefaults: ( ->
    subject: ''
    message: ''
  ).property('currentUser')


