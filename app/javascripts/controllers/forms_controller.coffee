require 'forms/call_form'
require 'forms/discussion_form'
require 'forms/meeting_form'
require 'forms/todo_form'
require 'forms/form_box'

Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']
  newMeeting: (->
    meeting = Radium.MeetingForm.create
      content:
        isNew: true
        users: Em.ArrayProxy.create(content: [])
        contacts: Em.ArrayProxy.create(content: [])
        user: @get('currentUser')
        startsAt: Ember.DateTime.create()
        endsAt: Ember.DateTime.create().advance({hour: 1})

    meeting
  ).property()

  editableMeeting: ( ->
    meeting = Radium.MeetingForm.create
      content: Radium.Meeting.find(1)
      isEditable: true

    meeting
  ).property()

  uneditableMeeting: (->
    users = Radium.User.find().slice(3, 6)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting'
        topic: 'Uneditable Meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 3)
        endsAt: Ember.DateTime.create().advance(day: 3).advance(hour: 3)
      isEditable: false
  ).property()

  editablePassedMeeting: ( ->
    users = Radium.User.find().slice(4)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)

      isEditable: true

  ).property()

  uneditablePassedMeeting: ( ->
    users = Radium.User.find().slice(2, 4)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)

      isEditable: false
  ).property()

  justAddedMeeting: ( ->
    users = Radium.User.find().slice(4)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 17)
        endsAt: Ember.DateTime.create().advance(day: 17).advance(hour: 3)

      isEditable: false
      justAdded: true
  ).property()

  uneditableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.createObject 'todo'
        user: @get('currentUser')
        reference: Factory.createObject('contact')
      isEditable: false
  ).property()

  newTodo: Radium.computed.newForm('todo')

  todoFormDefaults: ( ->
    finishBy: Ember.DateTime.create()
    user: @get('currentUser')
  ).property('currentUser')

  editableTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo'
        reference: Factory.createObject('contact')
  ).property()

  editableFinishedTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo'
        isFinished: true
  ).property()

  uneditableTodo: (->
    Radium.TodoForm.create
      isEditable: false
      content: Factory.createObject 'todo'
  ).property()

  uneditableFinishedTodo: (->
    Radium.TodoForm.create
      isEditable: false
      content: Factory.createObject 'todo'
        isFinished: true
  ).property()

  justAddedTodo: (->
    Ember.ObjectProxy.create
      content: Radium.TodoForm.create
        content: Factory.createObject 'todo'
      justAdded: true
  ).property()

  newCall: (->
    Radium.CallForm.create
      content: Ember.Object.create
        finishBy: Ember.DateTime.create()
      isNew: true
  ).property()

  editableCall: (->
    Radium.CallForm.create
      isEditable: true
      content: Factory.createObject 'call'
  ).property()

  editableFinishedCall: (->
    Radium.CallForm.create
      isEditable: true
      content: Factory.createObject 'call'
        isFinished: true
  ).property()

  uneditableCall: (->
    Radium.CallForm.create
      isEditable: false
      content: Factory.createObject 'call'
  ).property()

  uneditableFinishedCall: (->
    Radium.CallForm.create
      isEditable: false
      content: Factory.createObject 'call'
        finished: false
  ).property()

  justAddedCall: (->
    Ember.ObjectProxy.create
      content: Radium.CallForm.create
        content: Factory.createObject 'call'
      justAdded: true
  ).property()

  source: (->
    Ember.A([
      Ember.Object.create(name: "Adam")
      Ember.Object.create(name: "Paul")
      Ember.Object.create(name: "Sami")
      Ember.Object.create(name: "Riikka")
    ])
  ).property()

  discussion: (->
    Radium.DiscussionForm.create
      content: Ember.Object.create()
      isNew: true
  ).property()

  justAddedDiscussion: (->
    Ember.ObjectProxy.create
      content: Radium.DiscussionForm.create
        content: Ember.Object.create
          text: "Big long text"
      justAdded: true
  ).property()

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('newTodo')
      callForm: @get('newCall')
      discussionForm: @get('discussion')
      meetingForm: @get('newMeeting')
  ).property()
