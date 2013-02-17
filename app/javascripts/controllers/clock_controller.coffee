Radium.ClockController = Ember.ObjectController.extend
  tick: (seconds) ->
    @set 'model', @get('model').advance(second: seconds)

  now: Ember.computed.alias('model')

  beginningOfToday: (->
    @get('model').atBeginningOfDay()
  ).property('model')

  endOfToday: (->
    @get('model').atEndOfDay()
  ).property('model')

  endOfTomorrow: (->
    @get('model').advance(day: 1).atEndOfDay()
  ).property('model')

  endOfThisWeek: (->
    @get('model').atEndOfWeek()
  ).property('model')

  endOfNextWeek: (->
    @get('model').atEndOfWeek().advance(day: 1).atEndOfWeek()
  ).property()
