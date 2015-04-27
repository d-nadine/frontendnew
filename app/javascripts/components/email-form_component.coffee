Radium.TemplatePlaceholderMap =
  "name": "name"
  "company": "company"
  "signature": "signature"

Radium.EmailFormComponent = Ember.Component.extend Ember.Evented,
  actions:
    submit: (form) ->
      @set 'email.isDraft', false

      @sendAction 'saveEmail', form

      false

    toggleOptions: ->
      @toggleProperty 'showOptions'
      false

    submitFromPeople: (form) ->
      controller = @container.lookup('controller:peopleIndex')

      bulkParams = controller.get('content.params')

      bulkParams.returnFilter = bulkParams.filter
      bulkParams.returnParameters = user: bulkParams.user, tag: bulkParams.tag

      findRecord = (type, id) ->
        type.all().find (r) -> r.get('id') == id

      unless controller.get('allChecked')
        bulkParams.ids = controller.get('checkedContent').mapProperty('id')
        delete bulkParams.tag
        delete bulkParams.user
        bulkParams.filter = null
      else
        bulkParams.ids = []
        bulkParams.filter = controller.get('filter')

        if controller.get('tag') && controller.get('isTagged')
          bulkParams.tag = findRecord(Radium.Tag, bulkParams.tag)
        else if controller.get('isAssignedTo') && user_id = controller.get('user')
          bulkParams.user = findRecord(Radium.User, bulkParams.user)

      searchText = $.trim(controller.get('searchText') || '')

      if searchText.length
        bulkParams.like = searchText

      @sendAction 'createBulkEmail', form, bulkParams

      false

    createBulkEmail: (form) ->
      to = form.get('to')

      contactIds = to.filter((item) -> item.get('_personContact')).mapProperty('_personContact.id')

      tagIds = to.filter((item) -> item.get('resourceTag')).mapProperty('resourceTag.id')

      bulkParams =
        filter: null
        ids: contactIds || []
        tags: tagIds || []
        private: false
        public: true
        returnFilter: "all"
        returnParameters:
          tag: undefined
          user: undefined

      @sendAction 'createBulkEmail', form, bulkParams

      false

    saveAsDraft: (form, transitionFolder) ->
      @set 'email.isDraft', true
      @sendAction 'saveEmail', form, transitionFolder: transitionFolder

    scheduleDelivery: (form, date) ->
      if typeof date is "string"
        if date == 'tomorrow'
          date = Ember.DateTime.create().advance(day: 1)

      if @get('bulkMode')
        form.set 'sendTime', date

        if @get('fromPeople')
          return @send('submitFromPeople', form)

        return @send('createBulkEmail', form)

      @set 'email.sendTime', date
      @send 'saveAsDraft', form, 'scheduled'
      #Hack to close menu
      $(window).trigger('click.date-send-menu')

    showSendLater: ->
      @$('.send-later').css(display: 'inline-block')
      false

    setCheckForResponse: (date) ->
      @set 'email.checkForResponse', date
      @set('checkForResponseSet', true)
      @$('.check-response-opener').removeClass 'open'
      $(window).trigger('click.date-send-menu')
      false

    cancelCheckForResponse: (form) ->
      return unless @get('email.checkForResponse')

      form.set 'checkForResponse', null

      Ember.run.next =>
        @set('checkForResponseSet', false)

      @send('saveEmail', form) if @get('isDraft')

      false

    removeFromBulkList: (recipient) ->
      @get('email.to').removeObject recipient

      # FIXME: hack to stop the recipients list disappearing
      Ember.run.next =>
        @$('.bulk-recipients-component').css 'max-height': '107px'

      false

    insertPlaceholder: (placeholder) ->
      @EventBus.publish('placeholderInsered', placeholder)
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

    @$('.drop').on 'click', (e) =>
      @$('.check-response-opener').toggleClass('open')
      e.preventDefault()
      e.stopPropagation()


    $(window).on 'click.date-send-menu', (e) =>
      return true if e.target?.type == 'file'
      return true if e.target.tagName == 'A'

      target = $(e.target)

      return if target.hasClass('ui-timepicker-selected') || target.parents('.date-picker-component').length

      return if target.parents('.date-timepicker-component').length

      @$('.send-later').hide()
      @$('.check-response-opener').removeClass('open')

      e.preventDefault()
      e.stopPropagation()
      false

  _afterSetup: ->
    @$('.autocomplete.email input[type=text]').focus()

    return unless @get('fromPeople')

    toLength = @get('email.to.length')
    totalRecords = @get('email.totalRecords')

    return if toLength >= totalRecords

    remaining = totalRecords - toLength

    info = """
      <div class="bulk-recipient-component item">
        <div class="name">
          <b>Showing </b>
          <span class="count">#{toLength}</span>
          <span class="to-length">of</span>
          <span class="count">#{totalRecords}</span> selected contacts
        </div>
      </div>
    """

    @$('.bulk-recipients-component.recipients').append($(info))

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    el = @$('info')

    if el.data('tooltip')
      el.tooltip('destroy')

    @$('.drop').off 'click'
    $(window).off 'click.date-send-menu'

  isEditable: true
  signatureAdded: false
  showSignatureModal: false

  checkForResponse: Ember.computed.oneWay 'email.checkForResponse'
  checkForResponseFormatted: Ember.computed.oneWay 'email.checkForResponseFormatted'
  checkForResponseSet: false

  isScheduled: Ember.computed.oneWay 'email.isScheduled'
  sendTimeFormatted: Ember.computed.oneWay 'email.sendTimeFormatted'

  isSubmitted: Ember.computed.oneWay 'email.isSubmitted'

  isDraft: Ember.computed.oneWay 'email.isDraft'

  insertActions: Ember.computed ->
    placeholderMap = Radium.TemplatePlaceholderMap

    ret = Ember.A()

    for i of placeholderMap
      if placeholderMap.hasOwnProperty(i)
        item = Ember.Object.create(name: i, display: "{#{placeholderMap[i]}}")
        ret.pushObject item

    ret

  showNavigation: Ember.computed 'isDraft', 'forwardMode', 'replyMode', 'formMode', ->
    return if @get('isDraft') || @get('forwardMode') || @get('replyMode') || @get('formMode')

    true

  forwardOrReply: Ember.computed 'forwardMode', 'replyMode', ->
    @get('forwardMode') || @get('replyMode')

  showOptions: Ember.computed 'singleMode', 'bulkMode', 'replyMode', 'forwardMode', 'formMode', ->
    @get('singleMode') || @get('forwardMode') || @get('formMode')

  to: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.email.to'
    showAvatar: false
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.email.to.[]', ->
      return unless @get('controller.isSubmitted')

      !!!@get('controller.email.to.length')

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
  replyMode: Ember.computed.equal 'mode', 'reply'
  forwardMode: Ember.computed.equal 'mode', 'forward'
  formMode: Ember.computed.equal 'mode', 'form'

  messageIsInvalid: Ember.computed 'isSubmitted', 'email.html.length', ->
    return false unless @get('isSubmitted')

    message = @get('email.html') || ''

    !!!message.length

  submitAction: Ember.computed 'singleMode', 'bulkMode', 'fromPeople', ->
    if @get('singleMode') || @get('forwardOrReply') || @get('formMode')
      "submit"
    else if @get('bulkMode') && @get('fromPeople')
      "submitFromPeople"
    else
      "createBulkEmail"
