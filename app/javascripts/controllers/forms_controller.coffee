Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.TodoForm.create
      content: Radium.Todo.createRecord
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
      isNew: true
  ).property()

  editableTodo: (->
    Radium.TodoForm.create
      isEditable: true
      content: Factory.create 'todo'
        reference: Factory.create('contact')
  ).property()

  editableFinishedTodo: (->
    Radium.TodoForm.create
      isEditable: true
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
