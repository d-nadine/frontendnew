Radium.CalendarTaskRoute = Radium.Route.extend
  serialize: (model) ->
    taskType = model.constructor.toString().humanize().pluralize()

    task_type: taskType
    task_id: model.get('id')

  model: (params) ->
    type = params.task_type.constantize()
    type.find params.task_id

  setupController: (controller, task) ->
    calendarIndexController = @controllerFor('calendarIndex')

    calendarIndexController.set 'model', task.get('time')
    controller.set 'model', task

  renderTemplate: ->
    @render 'calendar/task',
      into: 'calendar'
