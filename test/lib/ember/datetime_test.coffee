module "Ember.DateTime"

test "toDateFormat", ->
  date = Ember.DateTime.create()
  equal date.toDateFormat(), date.toFormattedString('%Y-%m-%d')

test "toFullFormat", ->
  date = Ember.DateTime.create()
  equal date.toISO8601(), date.toFullFormat()
