class Populator
  @run: ->
    aaron = Factory.create 'user'
      name: 'Aaron Stephens'
      email: 'aaron.stephens13@feed-demo.com'
      phone: '136127245078'

    jerry = Factory.create 'user'
      name: 'Jerry Parker'
      email: 'jerry.parker@feed-demo.com'
      phone: '136127245071'

    ralph = Factory.create 'contact',
      display_name: 'Ralph'

    john = Factory.create 'contact'
      display_name: 'John'

    retrospection = Factory.create 'meeting',
      topic: 'Retrospection'
      location: 'Radium HQ'
      users: -> [
        aaron,
        jerry
      ]

    email = Factory.create 'email',
      sender:
        id: -> jerry
        type: 'user'

    group = Factory.create 'group',
      name: 'Product 1 group'

    developers = Factory.create 'group',
      name: 'Developers'

    phoneCall = Factory.create 'phone_call',
      to:
        id: -> aaron
        type: 'user'
      from:
        id: -> ralph
        type: 'contact'

    sms = Factory.create 'sms'

    deal = Factory.create 'deal',
      user: -> aaron

    todo = Factory.create 'todo',
      description: 'Finish first product draft',
      user: -> jerry

    overdue = Factory.create 'todo',
      description: 'Prepare product presentation',
      user: -> jerry
      overdue: true

    call = Factory.create 'todo',
      description: 'discussing offer details',
      finished: false,
      user: -> jerry,
      reference:
        id: -> ralph
        type: 'contact'

    dealTodo = Factory.create 'todo',
      description: 'Close the deal',
      user: -> jerry,
      reference:
        id: -> email
        type: 'email'

    emailTodo = Factory.create 'todo',
      description: 'write a nice response',
      user: -> jerry,
      reference:
        id: -> email
        type: 'email'

    groupTodo = Factory.create 'todo',
      description: 'schedule group meeting',
      user: -> jerry
      reference:
        id: -> group
        type: 'group'

    phoneCallTodo = Factory.create 'todo',
      user: -> jerry,
      description: 'product discussion'
      reference:
        id: -> phoneCall
        type: 'phone_call'

    smsTodo = Factory.create 'todo',
      description: 'product discussion',
      user: -> jerry,
      reference:
        id: -> sms
        type: 'sms'

    todoTodo = Factory.create 'todo',
      description: 'inception',
      user: -> jerry,
      reference:
        id: -> todo
        type: 'todo'

    callRalph = Factory.create 'todo',
      description: 'call ralph',
      user: -> jerry,
      kind: 'call'
      reference:
        id: -> ralph
        type: 'contact'

    finishByTomrrow = Factory.create 'todo',
      description: 'buy office equipment',
      user: -> jerry,
      finish_by: Ember.DateTime.create().advance(day: 1).toFullFormat()

    notification = Factory.create 'notification'
      reference:
        id: -> groupTodo
        type: 'todo'
      tag: 'assigned.todo'

    Factory.create 'notification',
      reference:
        id: -> retrospection
        type: 'meeting'
      tag: 'invited.meeting'

    reminder = Factory.create 'reminder'
      reference:
        id: -> finishByTomrrow
        type: 'todo'
      time: -> Ember.DateTime.create().advance(month: -1).toFullFormat()

    Factory.create 'reminder',
      reference:
        id: -> retrospection
        type: 'meeting'

    message = Factory.create 'message',
      message: 'here is a message'
      type: 'email'

    feeds = []

    @createFeedSection(0, [
        ['todo', todo]
        ['deal', deal]
        ['meeting', retrospection]
        ['deal', deal]
        ['phone_call', phoneCall]
        ['todo', overdue]
        ['todo', emailTodo]
        ['todo', groupTodo]
        ['todo', phoneCallTodo]
        ['todo', smsTodo]
        ['todo', todoTodo]
        ['todo', callRalph]
        ['todo', finishByTomrrow]
      ], feeds)

    defaultFeedItems = [
      ['todo', todo]
      ['deal', deal]
      ['todo', todoTodo]
    ]

    @createFeedSection(1, defaultFeedItems, feeds)
    @createFeedSection(7, defaultFeedItems, feeds)
    @createFeedSection(14, defaultFeedItems, feeds)
    @createFeedSection(30, defaultFeedItems, feeds)
    @createFeedSection(60, defaultFeedItems, feeds)
    @createFeedSection(90, defaultFeedItems, feeds)
    @createFeedSection(100, defaultFeedItems, feeds)

    sorted = feeds.sort (a, b) ->
      if a.id > b.id then 1 else -1

    sorted.forEach (item, i) ->
      if previous = sorted[i - 1]
        previous.next_date =  item.id
        item.previous_date =  previous.id
      if next = sorted.objectAt(i + 1)
        next.previous_date = item.id
        item.next_date =  next.id

    for feed in sorted
      Factory.create 'feed_section', feed

  @createFeedSection: (advance, items, feeds) ->
    advances = if advance == 0 then [advance] else [advance, (0 - advance)]

    for i in advances
      date = Ember.DateTime.create().advance(day: i)
      feeds.push
        id: date.toDateFormat()
        date: date.toFullFormat()
        item_ids: items

Radium.Populator = Populator
