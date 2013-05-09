require 'forms/email_form'

Radium.NewEmailForm = Radium.EmailForm.extend
  showAddresses: true
  showSubject: true

  reset: ->
    @set 'subject', '' 
    @set 'message', '' 
    @get 'to', []
    @get 'cc', []
    @get 'bcc', []
