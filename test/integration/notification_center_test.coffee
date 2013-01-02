module 'Integration - Notification Center'

integrationTest 'assigned todo notifications', ->
  todo = Factory.create 'todo'
    description: 'schedule group meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> todo
      type: 'todo'
    tag: 'assigned.todo'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.feedController').pushItem todo

  assertNotifications 1

  openNotifications()

  waitForSelector "#notifications", (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    click '#notifications ul li:first'

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'
