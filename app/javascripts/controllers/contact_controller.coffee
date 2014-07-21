Radium.ContactController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.TimeoutPollerMixin,
  actions:
    removeMultiple: (relationship, item) ->
      @get(relationship).removeObject item

    makeContactPublic: (contact) ->
      contact.set 'status', 'pipeline'

      transaction = @get('store').transaction()

      transaction.add(contact)

      contact.one 'didUpdate', (result) ->
        unless contact.get('isPersonal')
          contact.get('user').reload()

      contact.one 'becameInvalid', (result) =>
        @send 'flashError', contact
        result.reset()

      contact.one 'becameError', (result) =>
        transaction.rollback()
        @send 'flashError', 'An error has occurred and the contact cannot be updated.'
        result.reset()

      transaction.commit()

  needs: ['users', 'contacts','tags', 'companies', 'countries', 'accountSettings', 'leadStatuses']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  companies: Ember.computed.alias 'controllers.companies'
  # FIXME: How do we determine this?
  isEditable: true
  loadedPages: [1]

  dealsTotal: Ember.computed 'deals.[]', ->
    @get('deals').reduce((preVal, item) ->
      value = if item.get('status') == 'closed' then item.get('value') else 0

      preVal + value
    , 0, 'value')

  formBox: Ember.computed 'todoForm', 'callForm', 'discussionForm', ->
    Radium.FormBox.create
      compactFormButtons: true
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')
      # discussionForm: @get('discussionForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')
      about: @get('model')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: Ember.computed 'model', 'tomorrow', ->
    contact: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

  discussionForm: Radium.computed.newForm('discussion')

  discussionFormDefaults: Ember.computed 'model', ->
    reference: @get('model')
    user: @get('currentUser')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'model', ->
    reference: @get('model')
    user: @get('currentUser')

  isUpdatingDidChange: Ember.observer 'isUpdating', ->
    return unless @get('isUpdating')

    @start()

  onPoll: ->
    return @stop() unless @get('isUpdating')

    contact = @get('model')

    contact.one 'didReload', =>
      return @stop unless @get('isUpdating')

    contact.reload()

  stop: ->
    @_super.apply this, arguments
    clearInterval(@_timeout) if (@_timeout)

  finishSync: ->
    console.log 'in finishSync'

    @stop()

    return unless @get('isUpdating')

    contact = @get('model')

    observer = =>
      return unless contact.get('currentState.stateName') == "root.loaded.saved"

      contact.removeObserver 'currentState.stateName', observer

      contact.set 'updateStatus', 'updated'

      contact.one 'didUpdate', ->
        contact.reload()

      @get('store').commit()

    if contact.get('currentState.stateName') != "root.loaded.saved"
      contact.addObserver 'currentState.stateName', observer
    else
      observer()
