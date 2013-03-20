require 'forms/email_form'

Radium.DevelopmentEmailFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newEmail: Radium.computed.newForm('email')

  emailFormDefaults: ( ->
    subject: ''
    message: ''
    sender: @get('user')
    to: []
    cc: []
    bcc: []
  ).property('currentUser')


