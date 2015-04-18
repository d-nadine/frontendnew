Radium.TemplatePlaceholderMap =
  "name": "name"
  "company": "company"
  "signature": "signature"

Radium.EmailFormComponent = Ember.Component.extend Ember.Evented,
  actions:
    insertPlaceholder: (key) ->
      @trigger 'placeholderInsered', key
      false

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
      current = @get('email.html') || ''
      currentLength = current.length
      signature = @get('signature').replace(/\n/g, '<br/>')

      newMessage = "#{current}<br/><br/>#{signature}"

      @set 'email.html', newMessage
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

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @$('.info').tooltip(html: true)

    Ember.run.scheduleOnce 'afterRender', this, '_afterSetup'

  _afterSetup: ->
    @$('.autocomplete.email input[type=text]').focus()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    el = @$('info')

    if el.data('tooltip')
      el.tooltip('destroy')

  isEditable: true
  isSubmitted: false
  signatureAdded: false
  showSignatureModal: false

  insertActions: Ember.computed ->
    placeholderMap = Radium.TemplatePlaceholderMap

    ret = Ember.A()

    for i of placeholderMap
      ret.push("{#{placeholderMap[i]}}") if placeholderMap.hasOwnProperty(i)

    ret

  to: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.email.to'
    showAvatar: false
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.to.[]', ->
      return unless @get('controller.isSubmitted')

      @get('controller.email.to.length') == 0

    isValid: Ember.computed 'controller.email.to.[]', ->
      @get('controller.email.to.length') > 0

  cc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.email.cc'
    showAvatar: false

  bcc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.email.bcc'
    showAvatar: false

  signatureTextArea: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    isInvalid: Ember.computed 'value', 'targetObject.signatureSubmited', ->
      return unless @get('targetObject.signatureSubmited')

      @get('value').length == 0
