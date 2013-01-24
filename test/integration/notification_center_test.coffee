module 'Integration - Notification Center'

integrationTest 'lead notifications', ->
  contact = Factory.create 'contact'

  notification = Factory.create 'notification'
    reference:
      id: -> contact
      type: 'contact'
    tag: 'new.lead'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, contact.get('name')

    clickNotification notification

    assertOnPage contactPath(contact)

integrationTest 'contact assignment notifications', ->
  contact = Factory.create 'contact'

  notification = Factory.create 'notification'
    reference:
      id: -> contact
      type: 'contact'
    tag: 'assigned.contact'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, contact.get('name')

    clickNotification notification

    assertOnPage contactPath(contact)

integrationTest 'deal assignment notifications', ->
  deal = Factory.create 'deal'

  notification = Factory.create 'notification'
    reference:
      id: -> deal
      type: 'deal'
    tag: 'assigned.deal'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, deal.get('name')

integrationTest 'group assignment notifications', ->
  group = Factory.create 'group'

  notification = Factory.create 'notification'
    reference:
      id: -> group
      type: 'group'
    tag: 'assigned.group'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, group.get('name')

    clickNotification notification

    assertOnPage groupPath(group)

integrationTest 'todo assignments appear', ->
  todo = Factory.create 'todo'
    description: 'schedule group meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> todo
      type: 'todo'
    tag: 'assigned.todo'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    clickNotification notification

integrationTest  'meeting invitation notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'invited.meeting'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

integrationTest 'cancelled meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'cancelled.meeting'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

integrationTest 'confirmed meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'confirmed.meeting'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

integrationTest 'rejected meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'rejected.meeting'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

integrationTest 'rescheduled meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'rescheduled.meeting'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

integrationTest 'reminder notifications', ->
  todo = Factory.create 'todo'

  reminder = Factory.create 'reminder'
    reference:
      id: -> todo
      type: 'todo'
    time: -> Ember.DateTime.create().toFullFormat()

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    clickReminder reminder
