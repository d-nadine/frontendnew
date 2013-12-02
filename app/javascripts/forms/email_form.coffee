require 'forms/form'

Radium.EmailForm = Radium.Form.extend
  includeReminder: false
  reminderTime: 5
  files: Ember.A()

  init: ->
    @set 'content', Ember.Object.create()
    @_super()

  reset: ->
    @_super.apply this, arguments
    @set('subject', '')
    @set('message', '')
    @get('to').clear()
    @get('cc').clear()
    @get('bcc').clear()
    @get('files').clear()
    @get('attachedFiles').clear() if @get('attachedFiles')
    @set('isDraft', false)
    @set('bucket', Math.random().toString(36).substr(2,9))
    @set('sendTime', null)
    @set('checkForResponse', null)

  data: ( ->
    subject: @get('subject')
    message: @get('message')
    sentAt: Ember.DateTime.create()
    isDraft: @get('isDraft')

    to: @get('to').map (person) =>
      person.get('email')

    cc: @get('cc').map (person) =>
      person.get('email')

    bcc: @get('bcc').map (person) =>
      person.get('email')

    files: @get('files').map (file) =>
      file.get('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')
    sendTime: @get('sendTime')
    checkForResponse: @get('checkForResponse')
  ).property().volatile()

  isValid: ( ->
    @get('to.length') && @get('message.length')
  ).property('to.[]', 'message')
