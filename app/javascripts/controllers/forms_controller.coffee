Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.Todo.createRecord
      isNew: true
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()

  existingTodo: (->
    todo = Factory.create 'todo'
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
      reference: Factory.create('contact')

    # todo.get('comments').pushObject Factory.create('comment')
    # todo.get('comments').pushObject Factory.create('comment')
    # todo.get('comments').pushObject Factory.create('comment')
    # todo.get('comments').pushObject Factory.create('comment')

    todo
  ).property()
