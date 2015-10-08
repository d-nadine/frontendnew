require 'forms/form'
require 'forms/forms_attachment_mixin'


Radium.BulkEmailForm = Radium.Form.extend Radium.FormsAttachmentMixin,
  Radium.EmailPropertiesMixin,
  includeReminder: false
  reminderTime: 5
  showAddresses: true
  showSubject: true

  init: ->
    @set 'content', Ember.Object.create()
    @_super()

  reset: ->
    @set('id', null)

    @set 'to', Ember.A()
    @set 'isDraft', false
    @set 'sendTime', null
    @set 'checkForResponse', null
    @set('subject', '')
    @set('html', '')
    @set('sendTime', null)
    @set('totalRecords', 0)
    @_super.apply this, arguments

  data: Ember.computed( ->
    subject: @get('subject')
    html: @get('html')
    sentAt: Ember.DateTime.create()
    isDraft: @get('isDraft')

    to: @get('to').map (person) ->
      person.get('email')

    sendTime: @get('sendTime')
    files: @get('files').mapProperty('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')

  ).volatile()

  isValid: Ember.computed 'to.[]', 'html', ->
    @get('to.length') && @get('html.length')
