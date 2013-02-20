Ember.DateTime.reopen
  toMeridianTime: ->
    @toFormattedString('%i:%M %p')

  toDateFormat: ->
    @toFormattedString('%Y-%m-%d')

  toFullFormat: ->
    @toISO8601()

  isBetween: (start, end) ->
    return false if Ember.DateTime.compareDate(this, start) == -1
    return false if Ember.DateTime.compareDate(this, end) == 1
    true

  isBetweenExact: (start, end) ->
    return false if Ember.DateTime.compare(this, start) == -1
    return false if Ember.DateTime.compare(this, end) == 1
    true

  atEndOfDay: ->
    @adjust hour: 23, minute: 59, second: 59

  atBeginningOfDay: ->
    @adjust hour: 0, minute: 0, second: 0

  atBeginningOfDay: ->
    @adjust hour: 0, minute: 0, second: 0

  atBeginningOfMonth: ->
    @adjust day: 1, hour: 0, minute: 0, second: 0

  atEndOfMonth: ->
    @advance(month: 1).
      adjust(day: 1).
      advance(day: -1).
      adjust hour: 23, minute: 59, second: 59

  atEndOfWeek: ->
    day = 7 - @get 'dayOfWeek'

    @advance(day: day).
      adjust hour: 0, minute: 0, second: 0

  daysApart: (other) ->
    timeDiff = other.get('milliseconds') - @get('milliseconds')
    Math.ceil(timeDiff / (1000 * 3600 * 24))

  isToday: ->
    @toDateFormat() == Ember.DateTime.create().toDateFormat()

  isTomorrow: ->
    @toDateFormat() == Ember.DateTime.create().advance(day: 1).toDateFormat()

  isPast: ->
    @get('milliseconds') < Ember.DateTime.create().get('milliseconds')

  isFuture: ->
    @get('milliseconds') > Ember.DateTime.create().get('milliseconds')

  toHumanFormat: ->
    format = "%A, %B %D"

    if @isToday()
      "Today"
    else if @isTomorrow()
      "Tomorrow"
    else
      @toFormattedString(format)

Ember.DateTime.reopenClass
  random: (options = {}) ->
    multipler = ->
      if options.past
        -1
      else if options.future
        1
      else
        if Math.random() > 0.5 then 1 else -1

    randomUpTo = (max) ->
      Math.floor((Math.random() * max) + 1)

    @create().advance
      day: randomUpTo(180) * multipler()
      hour: randomUpTo(24) * multipler()
      minute: randomUpTo(60) * multipler()
