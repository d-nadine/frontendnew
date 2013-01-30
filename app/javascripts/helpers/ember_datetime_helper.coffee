Ember.DateTime.reopen
  differenceInDays: (other) ->
    timeDiff = other.get('_ms') - @get('_ms')
    Math.ceil(timeDiff / (1000 * 3600 * 24))

  isToday: (date) ->
    differenceInDays = Ember.DateTime.differenceInDays(date, Ember.DateTime.create())

    (differenceInDays == 0)
