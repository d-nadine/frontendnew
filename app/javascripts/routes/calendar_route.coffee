Radium.CalendarRoute = Radium.Route.extend
  setupController: (controller) ->
    @controllerFor('calendar').set('isCalendarDrawerOpen', true)
  events:
    toggleCalendarDrawer: ->
      @controllerFor('calendar').toggleProperty('isCalendarDrawerOpen')
      # @send 'toggleDrawer', 'calendar/select_user'

    selectUser: (user) ->
      @controllerFor('calendar').set 'user', user
      @send 'closeDrawer'

    selectDay: (calendarDay) ->
      calendarSidebarController = @controllerFor('calendarSidebar')
      calendarSidebarController.set('selectedDay', calendarDay)

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

  renderTemplate: ->
    @render 'calendar/index',
      into: 'calendar'
