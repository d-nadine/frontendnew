Radium.HasTasksMixin = Ember.Mixin.create
  tasks: Radium.computed.required()

  hasTasks: Ember.computed 'tasks.[]', ->
    @get('tasks.length')

  nextTask: Ember.computed 'tasks.firstObject', 'tasks.[]', ->
    currentTasks = @get('currentTasks')

    return unless currentTasks.get("length")

    for task in currentTasks by -1
      return task unless task.get("isFinished")

  currentTasks: Ember.computed 'tasks.[]', ->
    tasks = @get('tasks')

    return Ember.A() unless tasks.get('length')

    tasks.filter (task) ->
      return true unless task.get('time').isBeforeYesterday()

      return if task.constructor is Radium.Meeting

      not task.get('isFinished')

  notifyTasksChange: ->
    @notifyPropertyChange('currentTasks')
    @notifyPropertyChange('nextTask')
