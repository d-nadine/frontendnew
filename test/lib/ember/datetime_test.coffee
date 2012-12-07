module "Ember.DateTime"

test "ymd helper", ->
  date = Ember.DateTime.create()
  equal date.ymdFormat(), date.toFormattedString('%Y-%m-%d')
