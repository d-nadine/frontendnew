Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newMeeting: (->
    meeting = Radium.MeetingForm.create
      content: Radium.Meeting.createRecord
        isNew: true
        users: Em.ArrayProxy.create(content: [])
        user: @get('currentUser')
        startsAt: Ember.DateTime.create()
        endsAt: Ember.DateTime.create().advance({hour: 1})

    meeting
  ).property()

  editableMeeting: ( ->
    users = Radium.User.find()
    meeting = Radium.MeetingForm.create
      content: Factory.create 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 7)
        endsAt: Ember.DateTime.create().advance(day: 7).advance(hour: 3)

      isEditable: true

    meeting
  ).property()

  uneditableMeeting: (->
    users = Radium.User.find()
    Radium.MeetingForm.create
      content: Factory.create 'meeting'
        topic: 'Uneditable Meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 3)
        endsAt: Ember.DateTime.create().advance(day: 3).advance(hour: 3)
      isEditable: false
  ).property()

  editablePassedMeeting: ( ->
    users = Radium.User.find()
    Radium.MeetingForm.create
      content: Factory.create 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)

      isEditable: true

  ).property()

  uneditablePassedMeeting: ( ->
    users = Radium.User.find()
    Radium.MeetingForm.create
      content: Factory.create 'meeting'
        user: @get('currentUser')
        users: users
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)

      isEditable: false
  ).property()

  uneditableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  newTodo: (->
    Radium.TodoForm.create
      content: Radium.Todo.createRecord
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
      isNew: true
  ).property()

  editableTodo: (->
    Radium.TodoForm.create
      content: Factory.create 'todo'
        reference: Factory.create('contact')
  ).property()

  editableFinishedTodo: (->
    Radium.TodoForm.create
      content: Factory.create 'todo'
        isFinished: true
  ).property()

  uneditableTodo: (->
    Radium.TodoForm.create
      isEditable: false
      content: Factory.create 'todo'
  ).property()

  uneditableFinishedTodo: (->
    Radium.TodoForm.create
      isEditable: false
      content: Factory.create 'todo'
        isFinished: true
  ).property()

  justAddedTodo: (->
    Ember.ObjectProxy.create
      content: Radium.TodoForm.create
        content: Factory.create 'todo'
      justAdded: true
  ).property()

  newCall: (->
    Radium.CallForm.create
      content: Radium.Todo.createRecord
        finishBy: Ember.DateTime.create()
      isNew: true
  ).property()

  editableCall: (->
    Radium.CallForm.create
      isEditable: true
      content: Factory.create 'call'
  ).property()

  editableFinishedCall: (->
    Radium.CallForm.create
      isEditable: true
      content: Factory.create 'call'
        isFinished: true
  ).property()

  uneditableCall: (->
    Radium.CallForm.create
      isEditable: false
      content: Factory.create 'call'
  ).property()

  uneditableFinishedCall: (->
    Radium.CallForm.create
      isEditable: false
      content: Factory.create 'call'
        finished: false
  ).property()

  justAddedCall: (->
    Ember.ObjectProxy.create
      content: Radium.CallForm.create
        content: Factory.create 'call'
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
      content: Radium.Discussion.createRecord()
      isNew: true
  ).property()

  justAddedDiscussion: (->
    Ember.ObjectProxy.create
      content: Radium.DiscussionForm.create
        content: Radium.Discussion.createRecord
          text: "Big long text"
      justAdded: true
  ).property()

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('newTodo')
      callForm: @get('newCall')
      discussionForm: @get('discussion')
  ).property()
