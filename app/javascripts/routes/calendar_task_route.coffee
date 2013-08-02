Radium.CalendarTaskRoute = Radium.Route.extend
  serialize: (model) ->
    taskType = model.constructor.toString().humanize().pluralize()

    task_type: taskType
    task_id: model.get('id')

  model: (params) ->
    type = params.task_type.constantize()
    type.find params.task_id

  setupController: (controller, task) ->
    controller.set 'model', task

    @send 'selectDay', selectedDay

    calendarIndexController = @controllerFor('calendarIndex')

    unless calendarIndexController.get('model')
      calendarIndexController.set 'model', task.get('time')
      return

    calendarSidebar = @controllerFor('calendarSidebar')

    selectedDay = calendarSidebar.get('days').find (day) =>
      day.get('date').isTheSameDayAs(task.get('time'))

    calendarSidebar.set 'selectedDay', selectedDay

    calendarSidebar.set('selectedTask', task)

  renderTemplate: ->
    @render 'calendar/task',
      into: 'calendar'
