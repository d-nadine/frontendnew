Ember.DateTime::toDateFormat = ->
  @toFormattedString('%Y-%m-%d')

Ember.DateTime::toFullFormat = ->
  @toISO8601()
