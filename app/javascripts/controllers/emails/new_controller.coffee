require 'forms/email_form'

Radium.EmailsNewController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newEmail: Radium.computed.newForm('email')

  emailFormDefaults: ( ->
    isNew: true
    subject: ''
    message: ''
    sender: @get('user')
    to: []
    cc: []
    bcc: []
    showAddresses: false
    showSubject: false
  ).property('currentUser')
