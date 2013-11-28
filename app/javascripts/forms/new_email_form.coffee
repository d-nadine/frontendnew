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
    @set 'attachedFiles', Ember.A()
    @set 'isDraft', false
    @set 'bucket', Math.random().toString(36).substr(2,9)
    @set 'sendTime', null

Radium.DraftEmailForm = Radium.NewEmailForm.extend
  reset: ->
    @_super.apply this, arguments
    @set 'reference', null
