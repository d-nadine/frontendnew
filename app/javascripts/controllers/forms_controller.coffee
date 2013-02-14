Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.Todo.createRecord
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()

  existingTodo: (->
    Factory.create 'todo'
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
      reference: Factory.create('contact')
  ).property()

  uneditableTodo: (->
    Ember.ObjectProxy.create
      content: Factory.create 'todo'
        finishBy: Ember.DateTime.create()
        user: @get('currentUser')
        reference: Factory.create('contact')
      isEditable: false
  ).property()
