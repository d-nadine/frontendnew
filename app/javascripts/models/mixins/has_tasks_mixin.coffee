Radium.HasTasksMixin = Ember.Mixin.create
  tasks: (->
    tasks = Ember.A()

    Radium.Todo.all().forEach (todo) -> tasks.pushObject todo
    Radium.Meeting.all().forEach (todo) -> tasks.pushObject todo

    tasks
  ).property()

  nextTask: (->
    @get 'tasks.firstObject'
  ).property('tasks.firstObject')
