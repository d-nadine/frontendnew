class Populator
  @hasRun: false
  @run: ->
    #TODO move this to store definition
    # Factory.adapter = new Foundry.RadiumAdapter(Radium.get('router.store'))
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

    phone_call = Factory.create 'phone_call',
      to:
        id: -> aaron
        type: 'user'
      from:
        id: -> ralph
        type: 'contact'

    sms = Factory.create 'sms'

    notification = Factory.create 'notification'

    Factory.create 'notification',
      reference:
        id: -> Factory.build 'invitation'
        type: 'invitation'
      tag: 'invited.meeting'
      meeting: -> retrospection

    Factory.create 'invitation'

    deal = Factory.create 'deal',
      user: -> aaron

    campaign = Factory.create 'campaign',
      name: 'Fall product campaign'
      user: -> jerry

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

    campaignTodo = Factory.create 'todo',
      description: 'Prepare campaign plan',
      user: -> jerry,
      reference:
        id: -> campaign
        type: 'campaign'

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
        id: -> phone_call
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

    reminder = Factory.create 'reminder'

    Factory.create 'reminder',
      reference:
        id: -> retrospection
        type: 'meeting'

    message = Factory.create 'message',
      type: 'email'

    callList = Factory.create 'call_list',
      user: -> jerry

     @createFeedSection(0, [
        ['todo', todo]
        ['deal', deal]
        ['meeting', retrospection]
        ['deal', deal]
        ['call_list', callList]
        ['campaign', campaign]
        ['todo', campaignTodo]
        ['todo', emailTodo]
        ['todo', groupTodo]
        ['todo', phoneCallTodo]
        ['todo', smsTodo]
        ['todo', todoTodo]
        ['todo', callRalph]
        ['todo', finishByTomrrow]
      ])

    defaultFeedItems = [
      ['todo', todo]
      ['deal', deal]
    ]

    @createFeedSection(1, defaultFeedItems)
    @createFeedSection(7, defaultFeedItems)
    @createFeedSection(14, defaultFeedItems)

    Radium.Gap.FIXTURES = []
    Populator.hasRun = true

  @createFeedSection: (advance, items) ->
    advances = if advance == 0 then [advance] else [advance, (0 - advance)]

    for i in advances
      date = Ember.DateTime.create().advance(day: i)
      Factory.create 'feed_section',
        id: date.toDateFormat()
        date: date.toFullFormat() 
        item_ids: items

Radium.Populator = Populator
