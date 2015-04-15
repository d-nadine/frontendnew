Radium.EmailFormComponent = Ember.Component.extend
  actions:
    closeModal: ->
      @$().one $.support.transition.end, =>
        @set 'showSignatureModal', false

      @$('.modal').removeClass('in')

    addSignature: ->
      if signature = @get('signature')
        @send 'appendSignature'
      else
        @set 'showSignatureModal', true
        Ember.run.next =>
          @$('.modal').addClass 'in'
          @$('.modal textarea').focus()

    createSignature: ->
      @set 'signatureSubmited', true

      return unless @get('signature.length')

      @set 'signatureSubmited', false

      @sendAction 'addSignature', @get('signature')

      @send 'appendSignature'
      @send 'closeModal'

    appendSignature: ->
      editable = @$('.note-editable')
      current = @get('form.html') || ''
      currentLength = current.length
      signature = @get('signature').replace(/\n/g, '<br/>')

      newMessage = "#{current}<br/><br/>#{signature}"

      @set 'form.html', newMessage
      editable.html(newMessage)
      editable.height("+=50")
      editable.restoreCursor(currentLength)
      @set 'signatureAdded', true

    expandList: (section) ->
      @set("show#{section.capitalize()}", true)

    toggleEditorToolbar: ->
      @$('.note-toolbar').slideToggle "slow"

    hideAddSignature: ->
      @set 'signatureAdded', true

  isEditable: true
  isSubmitted: false
  signatureAdded: false
  showSignatureModal: false

  to: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.to'
    showAvatar: false
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.to.[]', ->
      return unless @get('controller.isSubmitted')

      @get('controller.form.to.length') == 0

    isValid: Ember.computed 'controller.form.to.[]', ->
      @get('controller.form.to.length') > 0

  cc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.cc'
    showAvatar: false

  bcc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.bcc'
    showAvatar: false

  signatureTextArea: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    isInvalid: Ember.computed 'value', 'targetObject.signatureSubmited', ->
      return unless @get('targetObject.signatureSubmited')

      @get('value').length == 0
