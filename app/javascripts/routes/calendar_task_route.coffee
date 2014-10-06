Radium.CalendarTaskRoute = Radium.Route.extend
  actions:
    deleteTask: (model) ->
      @transitionTo 'calendar.index', model.get('time')
      true

  serialize: (model) ->
    taskType = model.constructor.toString().humanize().pluralize()

    task_type: taskType
    task_id: model.get('id')

  model: (params) ->
    type = params.task_type.constantize()
    type.find params.task_id

  setupController: (controller, task) ->
    controller.set 'model', task

    if task.constructor is Radium.Todo
      task.set('isExpanded', !task.get("isFinished"))
    else if task.constructor is Radium.Meeting
      task.set('isExpanded', !task.get('isFinished'))

    @send 'selectDay', selectedDay

    calendarIndexController = @controllerFor('calendarIndex')

    unless calendarIndexController.get('model')
      calendarIndexController.set 'model', task.get('time')
      return

    calendarSidebar = @controllerFor('calendarSidebar')

    selectedDay = calendarSidebar.get('days').find (day) ->
      day.get('date').isTheSameDayAs(task.get('time'))

    calendarIndexController = @controllerFor('calendarIndex')

    calendarIndexController.set 'selectedDay', selectedDay

    calendarIndexController.set('selectedTask', task)

  renderTemplate: ->
    @render 'calendar/task',
      into: 'calendar'

  deactivate: ->
    @controller.set('isExpanded', false)
