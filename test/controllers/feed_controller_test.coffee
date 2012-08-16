test 'FeedController is FOOBAR', ->
  equal Radium.FeedController.create().get('foo'), 'bar'
