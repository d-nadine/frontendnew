Radium.computed = {}

Radium.computed.isToday = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    # FIXME: this should happen inside Ember.DateTime
    @get(dependentKey).toDateFormat() == Ember.DateTime.create().toDateFormat()

Radium.computed.pastDate = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    date = @get(dependentKey)

    return false unless date

    today = Ember.DateTime.create()

    Ember.DateTime.compareDate(today, date) == 1
