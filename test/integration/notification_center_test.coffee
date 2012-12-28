module 'Integration - Notification Center'

# FIXME: The setup for this test is ABSOLUTELY unacceptable.
# I don't know why this group nonsense is required. It 
# is not related to the test in anyway. Seems this is the only
# way to to get things to work
integrationTest 'assigned todo notifications', ->
  group = Factory.create 'group'
    name: 'Product 1 group'

  todo = Factory.create 'todo'
    description: 'schedule group meeting'
    reference:
      id: -> group
      type: 'group'

  notification = Factory.create 'notification'
    reference:
      id: -> todo
      type: 'todo'
    tag: 'assigned.todo'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.feedController').pushItem todo

  click '.notifications-link'

  waitForSelector "#notifications", (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    click '#notifications ul li:first'

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'
