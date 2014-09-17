require 'lib/radium/async_autocomplete_list_view'
require 'lib/radium/text_area'
require 'lib/radium/toggle_switch'

Radium.FormsEmailView = Radium.FormView.extend Radium.ScrollTopMixin,
  actions:
    closeModal: ->
      @$().one $.support.transition.end, =>
        @set 'showSignatureModal', false

      @$('.modal').removeClass('in')

    addSignature: ->
      if signature = @get('controller.signature')
        @send 'appendSignature'
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

    toggleSendMenu: ->
      @$('#sendMenu').toggleClass('open')
      event.preventDefault()
      event.stopPropagation()

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('signatureAdded', this, 'onSignatureAdded')

    @$('.btn').tooltip()

    @$('.date-time-menu').css left: '-100px'

    $('body').on 'click.date-send-menu', (e) =>
      return true if e.target?.type == 'file'
      return true if e.target.tagName == 'A'
      target = $(e.target)
      return if target.hasClass('ui-timepicker-selected') || target.parents('.timepicker').length
      return if target.parents('#sendMenu').length
      @$('#sendMenu').removeClass('open')
      e.preventDefault()
      e.stopPropagation()

  willDestroyElement: ->
    $('body').off 'click.date-send-menu'

  noContent: Ember.computed 'controller.isSubmitted', 'controller.message', ->
    return unless @get('controller.isSubmitted')

    not @get('controller.message.length')

  to: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.to'
    showAvatar: false
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.to.[]', ->
      return unless @get('controller.isSubmitted')

      @get('controller.to.length') == 0

    isValid: Ember.computed 'controller.to.[]', ->
      @get('controller.to.length') > 0

  cc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.bcc'
    showAvatar: false

  subject: Ember.TextField.extend
    valueBinding: 'targetObject.subject'

  body: Radium.TextArea.extend
    classNameBindings: [':message-body', 'parentView.noContent:is-invalid']
    valueBinding: 'targetObject.message'
    placeholder: 'Message'

  reminderLength: Ember.TextField.extend
    type: 'number'
    valueBinding: 'controller.reminderTime'
    disabled: Ember.computed.not('controller.includeReminder')

  signature: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    valueBinding: 'targetObject.signature'
    isInvalid: Ember.computed 'value', 'targetObject.signatureSubmited', ->
      return unless @get('targetObject.signatureSubmited')

      @get('value').length == 0

  onSignatureAdded: ->
    @send 'appendSignature'
    @send 'closeModal'
