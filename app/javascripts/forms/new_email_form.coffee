require 'forms/email_form'

Radium.NewEmailForm = Radium.EmailForm.extend Radium.EmailPropertiesMixin,
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
    @set 'checkForResponse', null

Radium.DraftEmailForm = Radium.NewEmailForm.extend
  reset: ->
    @_super.apply this, arguments
    @set 'id', null
    @set 'reference', null

  sendDraft: ( ->
    @get('id') && !@get('isDraft')
  ).property('id', 'isDraft')
