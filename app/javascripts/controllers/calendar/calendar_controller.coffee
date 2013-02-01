require 'radium/show_more_mixin'

CalendarItem = Ember.ObjectController.extend
  time: (->
    @get('finishBy') || @get('startsAt')
  ).property('content', 'finishBy', 'startsAt')

  label: (->
    @get('description') || @get('topic')
  ).property('description', 'topic')

Day = Ember.ArrayController.extend Radium.ShowMoreMixin,
  sortProperties: ['time']

  formattedDate: (->
    @get('date').toDateFormat()
  ).property('date')

  isDifferentMonth: (->
    @get('date.month') != @get('calendarDate.month')
  ).property('date')

  isToday: Radium.computed.isToday('date')

  day: (->
    @get('date.day')
  ).property('date')

Radium.CalendarController = Ember.Controller.extend
  date: (-> @get 'content').property('content')

  showCalendar: (context) ->
    console.log context

  items: (->
    items = []

    @get('todos').forEach (todo) -> items.pushObject todo
    @get('meetings').forEach (meeting) -> items.pushObject meeting

    items.map (item) -> CalendarItem.create(content: item)
  ).property('date')

  todos: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Todo.filter (todo) ->
      todo.get('finishBy').isBetween startDate, endDate
  ).property('date')

  meetings: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Meeting.filter (meeting) ->
      meeting.get('startsAt').isBetween startDate, endDate
  ).property('date')

  # FIXME: Why does this only work with ArrayController and 
  # not ArrayProxy

  dayNames: (->
    firstDay = Ember.DateTime.create().get('lastMonday')

    names = []

    for i in [0..6]
      names.push firstDay.advance(day: i).toFormattedString('%A')

    names
  ).property()

  nextMonth: (->
    @get('date').copy().advance(month: 1)
  ).property('date')

  lastMonth: (->
    @get('date').copy().advance(month: -1)
  ).property('date')

  startOfCalendar: (->
    date = @get('date').copy()

    firstDayOfMonth = date.adjust day: 1

    if firstDayOfMonth.get('dayOfWeek') == 1
      firstDayOfMonth
    else
      firstDayOfMonth.get('lastMonday')
  ).property('date')

  endOfCalendar: (->
    date = @get('date').copy()

    lastDayOfMonth = date.adjust(day: 1).
      advance(month: 1).
      advance(day: -1)

    if lastDayOfMonth.get('dayOfWeek') == 0
      lastDayOfMonth
    else
      lastDayOfMonth.get('nextSunday')
  ).property('date')

  weeks: (->
    weeks = []
    counter = 1
    days = []
    current = @get('startOfCalendar').copy()

    until current.get('milliseconds') > @get('endOfCalendar.milliseconds')
      startOfDay = current.copy().atBeginningOfDay()
      endOfDay = current.copy().atEndOfDay()

      dailyItems = @get('items').filter (item) ->
        item.get('time').isBetween startOfDay, endOfDay

      day = Day.create
        # FIXME this has to be here to override what's
        # set in the show more mixin
        perPage: 5

        date: current.copy()
        calendarDate: @get('date').copy()
        content: dailyItems

      days.push day

      if counter % 7 == 0
        weeks.push days
        days = []

      current = current.advance day: 1
      counter += 1

    weeks
  ).property('date')
