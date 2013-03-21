require 'lib/radium/autocomplete_list_view'

Radium.FormsEmailView = Radium.FormView.extend
  onFormReset: ->
    @$('form')[0].reset()

  to: Radium.AutocompleteView.extend
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: ( ->
      return unless @get('isSubmitted')

      not (@get('controller.to.length') > 0 || @get('controller.cc.length') > 0 ||  @get('controller.bcc.length') > 0)
    ).property('isSubmitted', 'controller.to.[]', 'controller.cc.[]', 'controller.bcc.[]')

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
    textArea.val("#{textArea.val()}\n\n#{@get('controller.signature')}")
    textArea.height("+=50")
    textArea.setCursorPosition(currentLength)
    @set 'signatureAdded', true
