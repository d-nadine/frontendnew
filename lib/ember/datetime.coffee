Ember.DateTime.reopen
  toDateFormat: ->
    @toFormattedString('%Y-%m-%d')

  toFullFormat: ->
    @toISO8601()

Ember.DateTime.reopenClass
  random: ->
    multipler = ->
     if Math.random() > 0.5 then 1 else -1

    randomUpTo = (max) ->
      Math.floor((Math.random() * max) + 1)

    @create().advance
      day: randomUpTo(180) * multipler()
      hour: randomUpTo(24) * multipler()
      minute: randomUpTo(60) * multipler()
