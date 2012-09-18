Radium.MeetingFormController = Ember.Object.extend Radium.FormValidation,
  init: ->
    @_super()
    @setDefaults()

  setDefaults: ->
    now = Ember.DateTime.create()
    hour = now.get('hour')
    minute = now.get('minute')
    start = Radium.Utils.roundTime(now)
    @setProperties
      startsAt: start
      endsAt: start.advance(hour: 1)
      topicValue: ''

    if (date = @get 'startsAtDate') && !@get('endsAtDate')
      @set 'endsAtDate', date

  topicValue: null
  startsAt:   null
  endsAt:     null
  endsAtDate: null

  startsAtDateBinding: 'Radium.currentFeedController.currentDate'

  # Cache the initial starts at value so we calculate the diff when adjusting endsAtValue
  startsAtWillChange: (->
    Ember.run.next this, ->
      @set '_startsAtCache', @get('startsAt')
  ).observesBefore('startsAt')

  startsAtDateWillChange: (->
    Ember.run.next this, ->
      @set '_startsAtDateCache', @get('startsAtDate')
  ).observesBefore('startsAtDate')

  startsAtDateDidChange: (->
    startsAtDate = @get 'startsAtDate'
    cache        = @get '_startsAtCache'
    endsAtDate   = @get 'endsAtDate'

    unless endsAtDate
      Ember.run.next this, ->
        @set 'endsAtDate', startsAtDate
    else
      diff = startsAtDate.get('day') - cache.get('day')
      if diff
        Ember.run.next this, ->
          @set 'endsAtDate', endsAtDate.advance(day: diff)
  ).observes('startsAtDate')

  startsAtDidChange: (->
    startsAt           = @get('startsAt')
    startsAtHour       = startsAt.get('hour')
    endsAt             = @get('endsAt')
    endsAtHour         = endsAt.get('hour')
    cachedStartsAtHour = @get('_startsAtCache.hour')
    diff               = (startsAtHour - cachedStartsAtHour)

    if diff
      Ember.run.next this, ->
        @set 'endsAtValue', endsAt.advance(hour: diff)
  ).observes('startsAt')

  pushItem: (item) ->
    Radium.get('router.feedController').pushItem(item)

  startsAtValue: Ember.computed( ->
    date = @get('startsAtDate')
    time = @get('startsAt')

    if time && date
      date = date.adjust(hour: time.get('hour'), minute: time.get('minute'))
  ).property('startsAt', 'startsAtDate')

  endsAtValue: Ember.computed( ->
    date = @get('endsAtDate')
    time = @get('endsAt')

    if time && date
      date = date.adjust(hour: time.get('hour'), minute: time.get('minute'))
  ).property('endsAt', 'endsAtDate')



  createMeeting: (data)  ->
    topic    = @get 'topicValue'
    startsAt = @get 'startsAtValue'
    endsAt   = @get 'endsAtValue'

    data =
      topic:    topic
      startsAt: startsAt
      endsAt:   endsAt

    meeting = Radium.store.createRecord Radium.Meeting, data
    @pushItem meeting
    Radium.store.commit()

  close: ->
    Radium.get('router.formController').close()

