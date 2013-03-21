require 'forms/form'

Radium.EmailForm = Radium.Form.extend
  data: ( ->
    subject: @get('subject')
    message: @get('message')
    sender: @get('user')
    sentAt: Ember.DateTime.create()
    to: []
    cc: []
    bcc: []
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @get('to').clear()
    @get('cc').clear()
    @get('bcc').clear()

  isValid: ( ->
    @get('to.length') && (@get('subject') || @get('message.length'))
  ).property('to.[]', 'subject', 'message')

  commit: ->
    email = Radium.Email.createRecord @get('data')

    email.set 'to', @get('to').mapProperty 'email'
    email.set 'cc', @get('cc').mapProperty 'email'
    email.set 'bcc', @get('bcc').mapProperty 'email'

    @get('store').commit()
