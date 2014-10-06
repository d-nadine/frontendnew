Radium.CalendarRoute = Radium.Route.extend
  actions:
    finishTask: (task) ->
      return unless task.constructor is Radium.Todo

      task.toggleProperty 'isFinished'

      onTask = @controller.get('controllers.application.currentPath') == "calendar.task"

      if onTask
        task.set('isExpanded', !task.get('isFinished'))
      else
        task.set('isExpanded', false)

      task.one 'didUpdate', (result) =>
        task.get('user')?.reload()

        unless reference =  task.get('reference')
          return

        reference.notifyTasksChange()

      @get('store').commit()

      if onTask && task != @controllerFor('calendarTask').get('model')
        @transitionTo 'calendar.task', task

    toggleCalendarDrawer: ->
      @controllerFor('calendar').toggleProperty('isCalendarDrawerOpen')

    selectUser: (user) ->
      @controllerFor('calendar').set 'user', user
      @send 'closeDrawer'

    selectDay: (calendarDay) ->
      calendarIndexController = @controllerFor('calendarIndex')
      calendarIndexController.set('selectedDay', calendarDay)

  setupController: (controller) ->
    @controllerFor('calendar').set('isCalendarDrawerOpen', true)

  renderTemplate: ->
    @render()

    @render 'calendar/sidebar',
      outlet: 'sidebar',
      into: 'calendar'

    @render 'calendar/drawer_buttons',
      outlet: 'buttons'
      into: 'application'

Radium.CalendarIndexRoute = Radium.Route.extend
  serialize: (model) ->
    {
      year: model.get('year')
      month: model.get('month')
      day: model.get('day')
    }

  model: (params) ->
    string = "#{params.year}-#{params.month}-#{params.day}"
    Ember.DateTime.parse string, "%Y-%m-%d"

  afterModel: (model, transition) ->
    controller = @controllerFor('calendarIndex')
    startOfCalendar = controller.firstDayOfMonth(model)
    dateKey = model.toDateFormat()

    map = controller.get('map')

    return if map.has dateKey

    map.set dateKey, model

    endOfCalendar = controller.lastDayOfMonth(model)

    return if !startOfCalendar || !endOfCalendar

    params =
      start_date: startOfCalendar.toDateFormat()
      end_date: endOfCalendar.toDateFormat()
      user_id: controller.get('currentUser.id')

    hash =
      todos: Radium.Todo.find(params)
      meetings: Radium.Meeting.find(params)

    controller.set 'isLoading', true

    Ember.RSVP.hash(hash).then =>
      controller.set 'isLoading', false

  renderTemplate: ->
    @render 'calendar/index',
      into: 'calendar'
