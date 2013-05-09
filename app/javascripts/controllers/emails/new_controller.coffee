require 'forms/new_email_form'

Radium.EmailsNewController = Radium.Controller.extend
  newEmail: Radium.NewEmailForm.create()
