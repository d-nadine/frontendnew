Radium.HasTasksMixin = Ember.Mixin.create
  tasks: Radium.computed.required()

  hasTasks: (->
    @get('tasks.length')
  ).property('tasks.length')

  nextTask: (->
    @get 'tasks.firstObject'
  ).property('tasks.firstObject')

  filteredTasks: ( ->
    tasks = @get('tasks')

    return Ember.A() unless tasks.get('length')

    tasks.filter (task) ->
      return true unless task.get('time').isBeforeYesterday()

      return if task.constructor is Radium.Meeting

      not task.get('isFinished')
  ).property('tasks.[]')
