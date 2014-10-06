Day = Ember.ArrayProxy.extend()

Radium.CalendarSidebarController = Radium.ObjectController.extend
  needs: ['calendarIndex']
  contentBinding: 'controllers.calendarIndex.user'
  isLoading: Ember.computed.alias 'controllers.calendarIndex.isLoading'

  items: Ember.computed 'controllers.calendarIndex.items', ->
    @get 'controllers.calendarIndex.items'

  date: Ember.computed 'controllers.calendarIndex.date', ->
    @get 'controllers.calendarIndex.date'

  isDifferentUser: Ember.computed 'content', 'currentUser', ->
    @get('content') != @get('currentUser')

  startOfCalendar: Ember.computed 'date', ->
    @get('date').copy().atBeginningOfMonth()

  endOfCalendar: Ember.computed 'date', ->
    @get('date').copy().atEndOfMonth()

  days: Ember.computed 'items', ->
    days = []
    items = @get 'items'
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    dates = @get('items').filter((i) ->
      i.get('time').isBetweenDates(startDate, endDate)
    ).map((i) ->
      i.get('time').toDateFormat()
    ).uniq()

    dates.forEach (date) ->
      dailyItems = items.filter (item) -> item.get('time').toDateFormat() == date

      day = Day.create
        content: dailyItems
        date: dailyItems.get('firstObject.time')

      days.pushObject day

    days
