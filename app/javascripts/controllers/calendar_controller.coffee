CalendarItem = Ember.ObjectController.extend()

Radium.CalendarIndexController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users', 'clock', 'calendarSidebar']

  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')
  selectedDay: Ember.computed.alias 'controllers.calendarSidebar.selectedDay'
  map: Ember.Map.create()

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  taskStartDate: ( ->
    @get('selectedDay.date') || @get('tomorrow')
  ).property('tomorrow', 'selectedDay.date')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
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
    date = @get('selectedDay.date') || Ember.DateTime.create()
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: date.advance(hour: 2)
    endsAt: date.advance(hour: 3)
    invitations: Ember.A()
  ).property('model', 'now', 'selectedDay.date')

  selectedDateDidChange: (->
    return unless @get('selectedDay.date') && @get('meetingForm')
    date = @get('selectedDay.date')
    Ember.run.next =>
      @set('meetingForm.startsAt', date.advance(hour: 2))
      @set('meetingForm.endsAt', date.advance(hour: 3))
  ).observes('selectedDay.date', 'meetingForm')

  users: Ember.computed.alias 'controllers.users'

  date: Ember.computed.alias 'content'

  items: (->
    items = []

    @get('todos').forEach (todo) -> items.pushObject todo
    @get('calls').forEach (call) -> items.pushObject call
    @get('meetings').forEach (meeting) -> items.pushObject meeting

    if user = @get('user')
      items = items.filter (item) =>
        item.constructor is Radium.Todo && item.get('user') == user ||
        item.constructor is Radium.Call && item.get('user') == user

    currentUser = @get('currentUser')

    items = items.reject (item) =>
      return false unless (item.constructor is Radium.Meeting) && item.get('organizer') && item.get('users.length')
      ((item.constructor is Radium.Meeting) && ((!item.get('users').contains(user)) && (item.get('organizer') != currentUser)))

    items.sort((a, b) ->
        Ember.DateTime.compare a.get('time'), b.get('time')
      ).map (item) -> CalendarItem.create(content: item)
  ).property('date', 'todos.[]', 'calls.[]',  'meetings.[]', 'user')

  todos: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Todo.filter (todo) ->
      todo.get('isLoaded') && todo.get('finishBy').isBetweenDates(startDate, endDate)
  ).property('date')

  calls: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Call.filter (call) ->
      call.get('isLoaded') && call.get('finishBy').isBetweenDates(startDate, endDate)
  ).property('date')

  meetings: (->
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    Radium.Meeting.filter (meeting) ->
      meeting.get('isLoaded') && meeting.get('startsAt').isBetweenDates(startDate, endDate)
  ).property('date')

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

    @firstDayOfMonth(date)
  ).property('date')

  endOfCalendar: (->
    date = @get('date').copy()

    @lastDayOfMonth(date)
  ).property('date')

  weeks: (->
    return [] if @get('isLoading')

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
  ).property('date', 'items.[]', 'user', 'isLoading')

  lastDayOfMonth: (date) ->
    lastDayOfMonth = date.adjust(day: 1).
      advance(month: 1).
      advance(day: -1)

    if lastDayOfMonth.get('dayOfWeek') == 0
      lastDayOfMonth
    else
      lastDayOfMonth.get('nextSunday')

  firstDayOfMonth: (date) ->
    firstDayOfMonth = date.adjust day: 1

    if firstDayOfMonth.get('dayOfWeek') == 1
      firstDayOfMonth
    else
      firstDayOfMonth.get('lastMonday')
