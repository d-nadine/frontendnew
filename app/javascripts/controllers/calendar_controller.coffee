CalendarItem = Ember.ObjectController.extend
  time: (->
    @get('finishBy') || @get('startsAt')
  ).property('content', 'finishBy', 'startsAt')

  title: (->
    @get('description') || @get('topic')
  ).property('description', 'topic')

Radium.CalendarController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users', 'clock', 'calendarSidebar']

  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')
  selectedDay: Ember.computed.alias 'controllers.calendarSidebar.selectedDay'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  taskStartDate: ( ->
    @get('selectedDay.date') || @get('tomorrow')
  ).property('tomorrow', 'selectedDay', 'date')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('taskStartDate')
    user: @get('currentUser')
  ).property('model', 'tomorrow', 'taskStartDate')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    contact: @get('contact')
    finishBy: @get('taskStartDate')
    user: @get('currentUser')
  ).property('model', 'tomorrow', 'taskStartDate')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()
  ).property('model', 'now')

  users: Ember.computed.alias 'controllers.users'

  date: (-> @get 'content').property('content')

  items: (->
    items = []

    @get('todos').forEach (todo) -> items.pushObject todo
    @get('meetings').forEach (meeting) -> items.pushObject meeting

    if user = @get('user')
      items = items.filter (item) =>
        item.constructor is Radium.Todo && item.get('user') == user ||
        item.constructor is Radium.Meeting && item.get('users').contains user

    items.map (item) -> CalendarItem.create(content: item)
  ).property('date', 'todos.[]', 'meetings.[]', 'user')

  todos: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Todo.filter (todo) ->
      todo.get('finishBy').isBetweenDates startDate, endDate
  ).property('date')

  meetings: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Meeting.filter (meeting) ->
      meeting.get('startsAt').isBetweenDates startDate, endDate
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
        item.get('time').isBetweenDates startOfDay, endOfDay

      day = Ember.ArrayProxy.create
        date: current.copy()
        content: dailyItems

      days.push day

      if counter % 7 == 0
        weeks.push days
        days = []

      current = current.advance day: 1
      counter += 1

    weeks
  ).property('date', 'items.[]', 'user')
