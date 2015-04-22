Radium.TemplatePlaceholderMap =
  "name": "name"
  "company": "company"
  "signature": "signature"

Radium.EmailFormComponent = Ember.Component.extend Ember.Evented,
  actions:
    insertPlaceholder: (placeholder) ->
      @trigger 'placeholderInsered', placeholder
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
      current = @get('html') || ''
      currentLength = editable.text().length
      signature = @get('signature').replace(/\n/g, '<br/>')

      newMessage = "#{current}<br/><br/>#{signature}"

      @set 'html', newMessage
      editable.html(newMessage)
      editable.height("+=50")

      # FIXME: editor menu appears sometims
      @$('ul.typeahead').hide()

      # FIXME: restore cursor to position
      # before signature added
      # editable.restoreCursor(currentLength)

      @set 'signatureAdded', true
      false

    expandList: (section) ->
      @set("show#{section.capitalize()}", true)

    toggleEditorToolbar: ->
      @$('.note-toolbar').slideToggle "slow"

    hideAddSignature: ->
      @set 'signatureAdded', true

    changeViewMode: (mode) ->
      @sendAction "changeViewMode", mode

      false

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
      if placeholderMap.hasOwnProperty(i)
        item = Ember.Object.create(name: i, display: "{#{placeholderMap[i]}}")
        ret.pushObject item

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

  bulk: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    showAvatar: false
    queryParameters: (query) ->
      scopes: ['user', 'contact', 'tag']
      term: query
      email_only: true

  signatureTextArea: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    isInvalid: Ember.computed 'value', 'targetObject.signatureSubmited', ->
      return unless @get('targetObject.signatureSubmited')

      @get('value').length == 0

  singleMode: Ember.computed.equal 'mode', 'single'
  bulkMode: Ember.computed.equal 'mode', 'bulk'
