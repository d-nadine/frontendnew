require 'lib/radium/autocomplete_list_view'
require 'lib/radium/text_area'
require 'lib/radium/toggle_switch'

Radium.FormsEmailView = Radium.FormView.extend
  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('signatureAdded', this, 'onSignatureAdded')

    @get('toList').focus() if @get('controller.showAddresses')
    @$('.btn').tooltip()

  noContent: ( ->
    return unless @get('controller.isSubmitted')

    not @get('controller.message.length')
  ).property('controller.isSubmitted', 'controller.message')

  to: Radium.AsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.to'
    showAvatar: false
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      @get('controller.to.length') == 0
    ).property('controller.isSubmitted', 'controller.to.[]')

    isValid: ( ->
      @get('controller.to.length') > 0
    ).property('controller.to.[]')

  cc: Radium.AsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.AsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.bcc'
    showAvatar: false

  subject: Ember.TextField.extend
    valueBinding: 'controller.subject'

  body: Radium.TextArea.extend
    classNameBindings: [':message-body', 'parentView.noContent:is-invalid']
    valueBinding: 'controller.message'
    placeholder: 'Message'

  reminderLength: Ember.TextField.extend
    type: 'number'
    valueBinding: 'controller.reminderTime'
    disabled: Ember.computed.not('controller.includeReminder')

  datePicker: Radium.DatePicker.extend
    click: (event)->
      # prevent bubbling up so the dropdown doesn't close
      event.stopPropagation()

  closeModal: ->
    @$().one $.support.transition.end, =>
      @set 'showSignatureModal', false

    @$('.modal').removeClass('in')

  addSignature: ->
    if signature = @get('controller.signature')
      @appendSignature()
    else
      @set 'showSignatureModal', true
      Ember.run.next =>
        @$('.modal').addClass 'in'
        @$('.modal textarea').focus()

  appendSignature: ->
    textArea = @$('.message-body')
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
