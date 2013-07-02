require 'forms/todo_form'
require 'controllers/deals/checklist_mixin'

Radium.DealController = Radium.ObjectController.extend Radium.ChecklistMixin,
  needs: ['accountSettings', 'users', 'contacts']

  # FIXME: this should be null and not an empty string
  deletionToken: ''

  # FIXME: How do we determine this?
  isEditable: true

  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  statuses: Ember.computed.alias('controllers.accountSettings.negotiatingStates')
  newItemDescription: ''
  newItemWeight: 0
  newItemFinished: false
  newItemDate: 0
  newItemKind: 'todo'

  contact: Ember.computed.alias('model.contact')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    description: null
    contact: @get('contact')
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
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()
  ).property('model', 'now')

  statusDisabled: Ember.computed.not('isPublic')

  toggleVisiblity: ->
    @toggleProperty 'isPublic'

  deletionNotConfirmed: (->
    @get('deletionToken') isnt @get('name')
  ).property('deletionToken')
