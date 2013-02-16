Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.Todo.createRecord
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()

  editableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  editableFinishedTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        isFinished: true
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  uneditableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  uneditableFinishedTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        isFinished: true
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  justAddedTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        isFinished: false
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
      justAdded: true
  ).property()

  newCall: (->
    Radium.Todo.createRecord
      kind: 'call'
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()

  editableCall: (->
    Ember.ObjectProxy.create
      content: Factory.create 'call'
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  editableFinishedCall: (->
    Ember.ObjectProxy.create
      content: Factory.create 'call'
        isFinished: true
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  uneditableCall: (->
    Ember.ObjectProxy.create
      content: Factory.create 'call'
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  uneditableFinishedCall: (->
    Ember.ObjectProxy.create
      content: Factory.create 'call'
        isFinished: true
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  justAddedCall: (->
    Ember.ObjectProxy.create
      content: Factory.create 'call'
        isFinished: false
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
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
    Ember.Object.create
      user: @get('currentUser')
  ).property()

  justAddedDiscussion: (->
    Ember.Object.create
      user: @get('currentUser')
      text: "Big long text from the discussion"
      justAdded: true
  ).property()
