require 'forms/email_form'

Radium.DevelopmentEmailFormsController = Radium.Controller.extend
  needs: ['contacts']

  newEmail: (->
    Radium.EmailForm.create
      subject: ''
      message: ''
      to: []
      cc: []
      bcc: []
  ).property()

  forwardEmail: (->
    Radium.ForwardEmailForm.create
      email: Ember.Object.create
        messaege: "This is the forwarded email"
  ).property()
