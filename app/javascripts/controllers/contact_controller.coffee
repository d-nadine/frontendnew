Radium.ContactController = Radium.ObjectController.extend
  needs: ['users', 'contacts','tags', 'companies', 'countries', 'accountSettings', 'leadStatuses']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  companies: Ember.computed.alias 'controllers.companies'

  makeContactPublic: (contact) ->
    contact.set 'status', 'pipeline'

    contact.one 'becameInvalid', =>
      Radium.Utils.generateErrorSummary deal

    contact.one 'becameError', =>
      Radium.Utils.notifyError 'An error has occurred and the contact cannot be updated.'

    @get('store').commit()

  # FIXME: How do we determine this?
  isEditable: true

  dealsTotal: ( ->
    @get('deals').reduce((preVal, item) ->
      value = if item.get('status') == 'closed' then item.get('value') else 0

      preVal + value
    , 0, 'value')
  ).property('deals.[]')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
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
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()
  ).property('model', 'now')

