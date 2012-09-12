Radium.MeetingFormController = Ember.Object.extend Radium.FormValidation,
  init: ->
    @_super()
    now = Ember.DateTime.create()
    hour = now.get('hour')
    minute = now.get('minute')
    start = Radium.Utils.roundTime(now)
    @setProperties
      startsAtValue: start
      endsAtValue: start.advance(hour: 1)

  topicValue:    null
  startsAtValue: null
  endsAtValue:   null

  # Cache the initial starts at value so we calculate the diff when adjusting endsAtValue
  startsAtWillChange: (->
    self = this
    Ember.run.next ->
      self.set '_startsAtCache', self.get('startsAtValue')

  ).observesBefore('startsAtValue')

  startsAtDidChange: (->
    self               = this
    startsAt           = @get('startsAtValue')
    startsAtHour       = startsAt.get('hour')
    endsAt             = @get('endsAtValue')
    endsAtHour         = endsAt.get('hour')
    cachedStartsAtHour = @get('_startsAtCache.hour')
    diff               = (startsAtHour - cachedStartsAtHour)
    Ember.run.next ->
      self.set 'endsAtValue', endsAt.advance(hour: (if (diff) then diff else 0))
  ).observes('startsAtValue')

  pushItem: (item) ->
    Radium.get('router.feedController').pushItem(item)

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

