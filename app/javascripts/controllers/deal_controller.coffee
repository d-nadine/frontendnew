require 'forms/todo_form'

Radium.DealController = Radium.ObjectController.extend
  # FIXME: this should be null and not an empty string
  deletionToken: ''

  needs: ['dealStatuses', 'users']

  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')

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
    reference: @get('contact')
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
    user: @get('currentUser')
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
  ).property('model', 'now')

  statusDisabled: Ember.computed.not('isPublic')

  toggleVisiblity: ->
    @toggleProperty 'isPublic'

  deletionNotConfirmed: (->
    @get('deletionToken') isnt @get('name')
  ).property('deletionToken')
