require 'forms/form'

Radium.EmailForm = Radium.Form.extend
  includeReminder: false
  reminderTime: 5

  data: ( ->
    subject: @get('subject')
    message: @get('message')
    sender: @get('user')
    sentAt: Ember.DateTime.create()
    addresses: 
      to: @get('to').mapProperty 'email'
      cc: @get('cc').mapProperty 'email'
      bcc: @get('bcc').mapProperty 'email'
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @get('to').clear()
    @get('cc').clear()
    @get('bcc').clear()

  isValid: ( ->
    @get('to.length') && (@get('subject') || @get('message.length'))
  ).property('to.[]', 'subject', 'message')
