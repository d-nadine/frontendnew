Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.Todo.createRecord
      finishBy: Ember.DateTime.create()
      user: @get('currentUser')
  ).property()
