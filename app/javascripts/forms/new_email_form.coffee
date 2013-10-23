require 'forms/email_form'

Radium.NewEmailForm = Radium.EmailForm.extend
  showAddresses: true
  showSubject: true

  reset: ->
    @set 'subject', '' 
    @set 'message', '' 
    @set 'to', []
    @set 'cc', []
    @set 'bcc', []
    @set 'files', Ember.A()
