Radium.FormsEmailController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleReminderForm: ->
      @toggleProperty 'includeReminder'

    toggleFormBox: ->
      @toggleProperty 'showFormBox'

    createSignature: ->
      @set 'signatureSubmited', true

      return unless @get('signature.length')

      @set 'signatureSubmited', false

      @get('settings').one 'didUpdate', =>
        @send 'flashSuccess', 'Signature updated'

      @get('store').commit()

      @trigger 'signatureAdded'

    submit: (form) ->
      @send 'sendEmail', form

  needs: ['tags','contacts','users','userSettings']
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'
  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
  user: Ember.computed.alias 'controllers.currentUser'
  isEditable: true

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')
  ).property('model', 'tomorrow', 'contact')

  expandList: (section) ->
    @set("show#{section.capitalize()}", true)
