require 'forms/todo_form'

Radium.DevelopmentTodoFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newTodo: Radium.computed.newForm('todo')

  todoFormDefaults: ( ->
    finishBy: Ember.DateTime.create()
    user: @get('currentUser')
  ).property('currentUser')

  editableTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo',
        reference: Factory.createObject('contact')
  ).property()

  editableFinishedTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo',
        isFinished: true
  ).property()

  uneditableTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo',
        isEditable: false
  ).property()

  uneditableFinishedTodo: (->
    Radium.TodoForm.create
      content: Factory.createObject 'todo',
        isFinished: true
        isEditable: false
  ).property()

  justAddedTodo: (->
    Ember.ObjectProxy.create
      content: Radium.TodoForm.create
        content: Factory.createObject 'todo',
      justAdded: true
  ).property()
