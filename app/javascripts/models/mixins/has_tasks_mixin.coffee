Radium.HasTasksMixin = Ember.Mixin.create
  tasks: (->
    tasks = Ember.A()

    @get('todos').forEach (todo) -> tasks.pushObject todo
    @get('meetings').forEach (meeting) -> tasks.pushObject meeting

    tasks
  ).property('meetings.[]', 'todos.[]')

  nextTask: (->
    @get 'tasks.firstObject'
  ).property('tasks.firstObject')
