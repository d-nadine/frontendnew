require 'lib/radium/autocomplete_list_view'
require 'lib/radium/text_area'

Radium.FormsEmailView = Radium.FormView.extend
  settings: Ember.computed.alias 'controller.controllers.settings'

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('signatureAdded', this, 'onSignatureAdded')

  noContent: ( ->
    return unless @get('controller.isSubmitted')

    not (@get('controller.subject') || @get('controller.message'))
  ).property('controller.isSubmitted', 'controller.subject', 'controller.message')

  to: Radium.AutocompleteView.extend
    sourceBinding: 'controller.to'
    showAvatar: false
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      @get('controller.to.length') == 0
    ).property('controller.isSubmitted', 'controller.to.[]')

    isValid: ( ->
      @get('controller.to.length') > 0
    ).property('controller.to.[]')

  cc: Radium.AutocompleteView.extend
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.AutocompleteView.extend
    sourceBinding: 'controller.bcc'
    showAvatar: false

  subject: Ember.TextField.extend
    valueBinding: 'controller.subject'
    placeholder: 'Subject'

  body: Ember.TextArea.extend
    classNameBindings: ['parentView.noContent:is-invalid']
    valueBinding: 'controller.message'
    placeholder: 'Message'

  reminderLength: Ember.TextField.extend
    classNames: ['field']
    type: 'number'
    value: 5

  closeModal: ->
    @$().one $.support.transition.end, =>
      @set 'showSignatureModal', false

    @$('.modal').removeClass('in')

  addSignature: ->
    signature = @get('controller.signature')

    if signature
      @appendSignature
    else
      @set 'showSignatureModal', true
      Ember.run.next =>
        @$('.modal').addClass 'in'
        @$('.modal textarea').focus()

  appendSignature: ->
    textArea = $('.body textarea')
    currentLength = textArea.val()?.length || 0
    textArea.val("#{textArea.val()}\n\n#{@get('controller.signature')}")
    textArea.height("+=50")
    textArea.setCursorPosition(currentLength)
    @set 'signatureAdded', true

  signature: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    valueBinding: 'controller.signature'
    isInvalid: ( ->
      return unless @get('controller.signatureSubmited')

      @get('value').length == 0
    ).property('value', 'controller.signatureSubmited')

  onSignatureAdded: ->
    @appendSignature()
    @closeModal()
