Radium.computed = {}

Radium.computed.isToday = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    # FIXME: this should happen inside Ember.DateTime
    @get(dependentKey).toDateFormat() == Ember.DateTime.create().toDateFormat()
