Ember.DateTime.reopenClass
  differenceInDays: (a, b) ->
    timeDiff = a.get('_ms') - b.get('_ms')
    Math.ceil(timeDiff / (1000 * 3600 * 24))

  isToday: (date) ->
    differenceInDays = Ember.DateTime.differenceInDays(date, Ember.DateTime.create())

    (differenceInDays == 0)
