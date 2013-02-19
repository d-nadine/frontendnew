Radium.HasTasksMixin = Ember.Mixin.create
  tasks: (->
    tasks = Ember.A()

    @get('todos').forEach (todo) -> tasks.pushObject todo
    @get('meetings').forEach (todo) -> tasks.pushObject todo

    tasks
  ).property('meetings.[]', 'todos.[]')

  nextTask: (->
    @get 'tasks.firstObject'
  ).property('tasks.firstObject')
