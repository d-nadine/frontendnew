require 'lib/radium/autocomplete_list_view'
require 'lib/radium/text_area'

Radium.FormsEmailView = Radium.FormView.extend
  noContent: ( ->
    return unless @get('controller.isSubmitted')

    not (@get('controller.subject') || @get('controller.message'))
  ).property('controller.isSubmitted', 'controller.subject', 'controller.message')

  to: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.to'
    showAvatar: false
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      @get('controller.to.length') == 0
    ).property('controller.isSubmitted', 'controller.to.[]')

  cc: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.AutocompleteView.extend
    addCurrentUser: false
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

  addSignature: ->
    console.log @$('#modal').length
    @$('#modal').addClass 'open'
    # textArea = $('.body textarea')
    # currentLength = textArea.val()?.length || 0
    # textArea.val("#{textArea.val()}\n\n#{@get('controller.signature')}")
    # textArea.height("+=50")
    # textArea.setCursorPosition(currentLength)
    # @set 'signatureAdded', true
