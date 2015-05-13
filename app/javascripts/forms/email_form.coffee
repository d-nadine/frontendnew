require 'forms/form'
require 'forms/forms_attachment_mixin'

Radium.EmailForm = Radium.Form.extend Radium.FormsAttachmentMixin,
  Radium.EmailPropertiesMixin,

  includeReminder: false
  reminderTime: 5
  showAddresses: true
  showSubject: true

  init: ->
    @set 'content', Ember.Object.create()
    @_super()

  reset: (bubbles = true)->
    @set('id', null)
    to = if to = @get('defaults.to')
            to
         else
           Ember.A()

    @set 'to', to
    @set 'cc', Ember.A()
    @set 'bcc', Ember.A()
    @set 'bulkList', Ember.A()
    @set 'isDraft', false
    @set 'sendTime', null
    @set 'checkForResponse', null
    @set('subject', '')
    @set('html', '')
    @set('isDraft', false)
    @set('sendTime', null)
    @set('checkForResponse', null)
    @set('deal', null)
    @set('repliedTo', null)

    if eventBus = @EventBus
      eventBus.publish('reset') if bubbles

    @_super.apply this, arguments

  data: Ember.computed( ->
    subject: @get('subject')
    html: @get('html')
    sentAt: Ember.DateTime.create()
    isDraft: @get('isDraft')

    to: @get('to').map (person) ->
      person.get('email')

    cc: @get('cc').map (person) ->
      person.get('email')

    bcc: @get('bcc').map (person) ->
      person.get('email')

    sendTime: @get('sendTime')
    checkForResponse: @get('checkForResponse')
    files: @get('files').mapProperty('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')

    deal: @get('deal')
    repliedTo: @get('repliedTo')
  ).volatile()

  isValid: Ember.computed 'to.[]', 'html', ->
    @get('to.length') && @get('html.length')

Radium.DraftEmailForm = Radium.EmailForm.extend
  init: ->
    @set 'content', Ember.Object.create()

  reset: ->
    @_super.apply this, arguments
    @set 'id', null
    @set 'reference', null

  sendDraft: Ember.computed 'id', 'isDraft', ->
    @get('id') && !@get('isDraft')
