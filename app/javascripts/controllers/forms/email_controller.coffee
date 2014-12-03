Radium.FormsEmailController = Radium.ObjectController.extend  Ember.Evented,
  Radium.EmailDealMixin,

  actions:
    toggleReminderForm: ->
      @set 'showingAddDeal', false
      @toggleProperty 'includeReminder'
      return false

    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return false

    createSignature: ->
      @set 'signatureSubmited', true

      return unless @get('signature.length')

      @set 'signatureSubmited', false

      @get('settings').one 'didUpdate', =>
        @send 'flashSuccess', 'Signature updated'

      @get('store').commit()

      @trigger 'signatureAdded'

    saveAsDraft: (form, transitionFolder) ->
      @set 'isDraft', true
      @send 'saveEmail', form, transitionFolder: transitionFolder

    scheduleDelivery: (form, date) ->
      if typeof date is "string"
        if date == 'tomorrow'
          date = Ember.DateTime.create().advance(day: 1)

      form.set 'sendTime', date
      @send 'saveAsDraft', form, 'scheduled'
      #Hack to close menu
      $('#sendMenu').removeClass('open')
      $(document).trigger('click.date-send-menu')

    setCheckForResponse: (form, date) ->
      form.set 'checkForResponse', date
      @send 'toggleReminderForm'
      @send('saveEmail', form) if @get('isDraft')

    cancelCheckForResponse: (form) ->
      form.set 'checkForResponse', null
      @send('saveEmail', form) if @get('isDraft')

    cancelDelivery: (form) ->
      form.set 'sendTime', null
      @send 'saveAsDraft', form, 'drafts'

    submit: (form) ->
      @set 'isDraft', false

      if @get('bulkEmail')
        filterParams = @get('controllers.peopleIndex.content.params')
        unless filterParams
          return @send "flashError", "You need to select some contacts from the contacts main page."

        return @send 'saveEmail', form, bulkEmailParams: filterParams, bulkEmail: true

      @send 'saveEmail', form
      false

    toggleAddDealForm: ->
      @set 'includeReminder', false
      @toggleProperty 'showingAddDeal'
      false

  showingAddDeal: false

  needs: ['tags','contacts','users','userSettings', 'deals', 'emailsNew', 'peopleIndex']
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'
  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
  user: Ember.computed.alias 'controllers.currentUser'
  bulkEmail: Ember.computed.oneWay 'controllers.emailsNew.isBulkEmail'
  isEditable: true

  disableSave: false

  formBox: Ember.computed 'todoForm', 'callForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')


  messageIsInvalid: Ember.computed 'isSubmitted', 'message.length', ->
    return false unless @get('isSubmitted')

    not @get('message.length')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: Ember.computed 'model', 'tomorrow', 'contact', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')

  expandList: (section) ->
    @set("show#{section.capitalize()}", true)
