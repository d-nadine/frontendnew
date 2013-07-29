require 'forms/todo_form'
require 'controllers/deals/checklist_mixin'

Radium.DealController = Radium.DealBaseController.extend Radium.ChecklistMixin,
  needs: ['accountSettings', 'users', 'contacts']
  firstState: Ember.computed.alias('controllers.accountSettings.firstState')

  isPublic: Ember.computed.not 'isUnpublished'
  statusDisabled: Ember.computed.not('isPublic')

  # FIXME: this should be null and not an empty string
  deletionToken: ''

  # FIXME: How do we determine this?
  isEditable: true

  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  contact: Ember.computed.alias('model.contact')

  formBox: (->
    Radium.FormBox.create
      compactFormButtons: true
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
    reference: @get('model')
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
    reference: @get('model')
  ).property('model', 'now')

  togglePublished: ->
    status = if @get('isPublic')
               "unpublished"
             else
               @get('firstState')

    @set 'status', status

    @get('store').commit()

  deletionNotConfirmed: (->
    @get('deletionToken') isnt @get('name')
  ).property('deletionToken')
