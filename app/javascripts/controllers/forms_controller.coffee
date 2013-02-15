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
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  editableFinishedTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        isFinished: true
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: true
  ).property()

  uneditableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  uneditableFinishedTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        isFinished: true
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()

  callTodo: (->
    Radium.Todo.createRecord
      kind: 'call'
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()

  callTodoWithContext: (->
    Radium.Todo.createRecord
      kind: 'call'
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
      reference: Factory.create('contact')
  ).property()

  existingCall: (->
    Factory.create 'call'
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
      reference: Factory.create('contact')
  ).property()
