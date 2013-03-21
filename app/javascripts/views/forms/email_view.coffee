require 'lib/radium/autocomplete_list_view'

Radium.NoRecipientLitMixin = Ember.Mixin.create
  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: ( ->
    return unless @get('isSubmitted')

    @get('controller.to.length') ||@get('controller.cc.length') || @get('controller.bcc.length')

  ).property('to.[]', 'cc.[]', 'bcc.[]')

Radium.FormsEmailView = Radium.FormView.extend
  onFormReset: ->
    @$('form')[0].reset()

  to: Radium.AutocompleteView.extend Radium.NoRecipientLitMixin,
    addCurrentUser: false
    sourceBinding: 'controller.to'
    showAvatar: false

  cc: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.bcc'
    showAvatar: false

  subject: Ember.TextArea.extend
    classNames: ['field']
    valueBinding: 'controller.subject'
    placeholder: 'Subject'

    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

  body: Ember.TextArea.extend
    classNames: ['field']
    valueBinding: 'controller.message'
    placeholder: 'Message'

    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

  reminderLength: Ember.TextField.extend
    classNames: ['field']
    type: 'number'
    value: 5

  addSignature: ->
    textArea = $('.body textarea')
    currentLength = textArea.val()?.length || 0
    # FIXME: retrieve signature
    textArea.val("#{textArea.val()}\n\n#{@get('controller.signature')}")
    textArea.height("+=50")
    textArea.setCursorPosition(currentLength)
    @set 'signatureAdded', true
