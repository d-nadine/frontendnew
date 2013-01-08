Radium.Utils = Em.Object.create
  runWhenLoaded: (object, callback) ->
    if object.get('isLoaded')
      Ember.run.next ->
        callback.apply object
    else
      observer = ->
        callback.apply object
        object.removeObserver 'isLoaded', observer

      object.addObserver 'isLoaded', observer

  scroll: (elementOrClassName, callback) ->
    Ember.run.next ->
      element = null
      if elementOrClassName instanceof jQuery
        element = elementOrClassName
      else
        element = $(".#{elementOrClassName}")

      element.ScrollTo
        duration: 500
        offsetTop: 100
        callback: ->
          callback() if callback?

  scrollWhenLoaded: (collection, className, callback) ->
    self = this
    observer = ->
      if !collection.get('isLoading')
        collection.removeObserver('isLoading', observer)
        self.scroll(className, callback)

    if collection.get('isLoading')
      collection.addObserver 'isLoading', observer
    else
      self.scroll(className, callback)

  roundTime: (time) ->
    hour = time.get("hour")
    minute = time.get("minute")
    newTime = undefined
    if minute is 0
      newTime = time
    else if minute <= 29
      newTime = time.adjust(minute: 30)
    else
      newTime = time.adjust(
        hour: hour + 1
        minute: 0
      )
    newTime

  rangeForDate: (date, range) ->
    if range == 'weekly'
      dayOfTheWeek = date.toFormattedString('%w')

      if dayOfTheWeek == '0'
        dayOfTheWeek = '7'

      dayOfTheWeek = parseInt dayOfTheWeek

      dayAdjustment = 1 - dayOfTheWeek
      startOfWeek  = date.advance(day: dayAdjustment)

      id      = "#{startOfWeek.toDateFormat()}-week"
      date    = startOfWeek
      endDate = date.advance day: 6

    else if range == 'monthly'
      startOfMonth = date.adjust(day: 1)

      id      = "#{startOfMonth.toDateFormat()}-month"
      date    = startOfMonth
      endDate = date.advance(month: 1).advance(day: -1)

    [date, endDate]
