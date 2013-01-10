Radium.CalendarView = Em.View.extend
  templateName: 'radium/calendar'

  init: ->
    @_super.apply this, arguments

  # FIXME: this should be bound to the calendar controller
  # It would never be bound to any other feed controller
  controllerBinding: 'Radium.currentFeedController'
  currentDateBinding: 'controller.currentDate'

  monthly: (->
    @get('controller.range') == 'monthly'
  ).property('controller.range')

  currentMonth: (->
    date = @get 'currentDate'
    date.toFormattedString '%B %Y'
  ).property('currentDate')

  currentYear: (->
    date = @get 'currentDate'
    date.toFormattedString '%Y'
  ).property('currentDate')

  previousYear: (->
    date = @get 'currentDate'
    date.advance(year: -1).toFormattedString '%Y'
  ).property('currentDate')

  nextYear: (->
    date = @get 'currentDate'
    date.advance(year: 1).toFormattedString '%Y'
  ).property('currentDate')

  nextMonth: (->
    date = @get 'currentDate'
    date.advance(month: 1).toFormattedString '%B %Y'
  ).property('currentDate')

  previousMonth: (->
    date = @get 'currentDate'
    date.advance(month: -1).toFormattedString '%B %Y'
  ).property('currentDate')

  dayHeaders: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

  months: (->
    months = []
    for i in [1..12]
      months.pushObject Ember.DateTime.create(month: i, day: 1)

    months
  ).property()

  days: (->
    dates = []
    date = @get 'currentDate'

    beginningOfMonth = date.adjust(day: 1)
    dayOfTheWeek     = parseInt beginningOfMonth.toFormattedString('%w')
    beginningOfWeek  = beginningOfMonth.advance(day: -dayOfTheWeek)

    endOfMonth   = date.adjust(day: 1).advance(month: 1, day: -1)
    dayOfTheWeek = parseInt endOfMonth.toFormattedString('%w')
    endOfWeek    = endOfMonth.advance(day: 6 - dayOfTheWeek)

    current = beginningOfWeek
    while Ember.DateTime.compare(current, endOfWeek) <= 0
      dates.pushObject current
      current = current.advance(day: 1)

    dates
  ).property('currentMonth')

  switchToPreviousMonth: ->
    @setCurrentDate @get('currentDate').advance(month: -1)

  switchToNextMonth: ->
    @setCurrentDate @get('currentDate').advance(month: 1)

  switchToPreviousYear: ->
    @setCurrentDate @get('currentDate').advance(year: -1)

  switchToNextYear: ->
    @setCurrentDate @get('currentDate').advance(year: 1)

  setCurrentDate: (date) ->
    Radium.get('router').send 'showDate', date: date

  # TODO: MonthView and DayView could share a lot of functionality
  MonthView: Em.View.extend
    template: Ember.Handlebars.compile('{{view.formattedMonth}}')
    classNameBindings: ['active']
    currentDateBinding: 'parentView.currentDate'
    tagName: 'li'

    active: (->
      @get('month').toFormattedString('%m') == @get('currentDate').toFormattedString('%m')
    ).property('currentDate', 'month')

    formattedMonth: (->
      @get('month').toFormattedString('%B')
    ).property('month')

    click: ->
      @get('parentView').setCurrentDate @get('month')

  DayView: Em.View.extend
    template: Ember.Handlebars.compile('{{view.formattedDay}}')
    classNameBindings: ['active', 'otherMonth', 'identifier']
    currentDateBinding: 'parentView.currentDate'
    tagName: 'li'

    identifier: (->
      "day-#{@get('day').toFormattedString('%d')}"
    ).property('day')

    active: (->
      format = '%Y-%m-%d'
      @get('day').toFormattedString(format) == @get('currentDate').toFormattedString(format)
    ).property('currentDate', 'day')

    otherMonth: (->
      @get('day').toFormattedString('%m') != @get('currentDate').toFormattedString('%m')
    ).property('currentDate', 'day')

    formattedDay: (->
      @get('day').toFormattedString('%d')
    ).property('day')

    click: ->
      @get('parentView').setCurrentDate @get('day')
