Radium.ContactController = Radium.ObjectController.extend
  needs: ['users', 'contacts','tags', 'companies', 'countries', 'accountSettings', 'leadStatuses']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  companies: Ember.computed.alias 'controllers.companies'
  # FIXME: How do we determine this?
  isEditable: true

  removeMultiple: (relationship, item) ->
    @get(relationship).removeObject item

  makeContactPublic: (contact) ->
    contact.set 'status', 'pipeline'

    transaction = @get('store').transaction()

    transaction.add(contact)

    contact.one 'becameInvalid', (result) =>
      @send 'flashError', contact
      result.reset()

    contact.one 'becameError', (result) =>
      transaction.rollback()
      @send 'flashError', 'An error has occurred and the contact cannot be updated.'
      result.reset()

    transaction.commit()

  dealsTotal: ( ->
    @get('deals').reduce((preVal, item) ->
      value = if item.get('status') == 'closed' then item.get('value') else 0

      preVal + value
    , 0, 'value')
  ).property('deals.[]')

  formBox: (->
    Radium.FormBox.create
      compactFormButtons: true
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
      about: @get('model')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    contact: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  discussionForm: Radium.computed.newForm('discussion')

  discussionFormDefaults: (->
    reference: @get('model')
    user: @get('currentUser')
  ).property('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()
  ).property('model', 'now')

