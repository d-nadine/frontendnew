CalendarItem = Ember.ObjectController.extend
  time: (->
    @get('finishBy') || @get('startsAt')
  ).property('content', 'finishBy', 'startsAt')

  title: (->
    @get('description') || @get('topic')
  ).property('description', 'topic')

Radium.CalendarController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users', 'clock']

  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: (->
    Radium.CallForm.create
      canChangeContact: false
      content: Ember.Object.create
        reference: @get('contact')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

  meetingForm: ( ->
    Radium.MeetingForm.create
      content: Ember.Object.create
        isNew: true
        users: Em.ArrayProxy.create(content: [])
        contacts: Em.ArrayProxy.create(content: [])
        user: @get('currentUser')
        startsAt: @get('now')
        endsAt: @get('now').advance(hour: 1)
  ).property('model', 'now')

  users: (->
    @get('controllers.users')
  ).property('controllers.users')

  date: (-> @get 'content').property('content')

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
  ).property('date')
