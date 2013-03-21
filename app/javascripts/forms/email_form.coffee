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
    @get('to.length') && (@get('subject.length') || @get('message.length'))
  ).property('to.[]', 'subject', 'message')

  commit: ->
    email = Radium.Email.createRecord @get('data')

    @get('to').forEach (recipient) ->
      email.get('to').addObject recipient.get('email')

    @get('cc').forEach (recipient) ->
      email.get('cc').addObject recipient.get('email')

    @get('bcc').forEach (recipient) ->
      email.get('bcc').addObject recipient.get('email')

    @get('store').commit()
