Radium.ClockController = Ember.ObjectController.extend
  tick: (seconds) ->
    @set 'model', @get('model').advance(second: seconds)

  now: Ember.computed.alias('model')

  beginningOfDay: Ember.computed 'model', ->
    @get('model').atBeginningOfDay()

  endOfDay: Ember.computed 'model', ->
    @get('model').atEndOfDay()

  endOfTomorrow: Ember.computed 'model', ->
    @get('model').advance(day: 1).atEndOfDay()

  endOfThisWeek: Ember.computed 'model', ->
    @get('model').atEndOfWeek()

  endOfNextWeek: Ember.computed ->
    @get('model').atEndOfWeek().advance(day: 1).atEndOfWeek()
