class FixtureCreator
  @isInitialised: false
  @populate: ->
    #TODO move this to store definition
    Factory.adapter = new Foundry.RadiumAdapter(Radium.get('router.store'))
    aaron = Factory.create 'user',
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

    Factory.create 'invitation'

    deal = Factory.create 'deal',
      user: -> aaron

    campaign = Factory.create 'campaign',
      name: 'Fall product campaign'
      user: -> jerry

    todoUser =
      user: -> jerry

    todo = Factory.create 'todo', todoUser,
      description: 'Finish first product draft'

    overdue = Factory.create 'todo', todoUser,
      description: 'Prepare product presentation'
      user: -> jerry
      overdue: true

    call = Factory.create 'todo', todoUser,
      description: 'discussing offer details'
      finished: false
      reference:
        id: -> ralph
        type: 'contact'

    dealTodo = Factory.create 'todo', todoUser,
      description: 'Close the deal'
      reference:
        id: -> email
        type: 'email'

    campaignTodo = Factory.create 'todo', todoUser,
      description: 'Prepare campaign plan'
      reference:
        id: -> campaign
        type: 'campaign'

    emailTodo = Factory.create 'todo', todoUser,
      description: 'write a nice response'
      reference:
        id: -> email
        type: 'email'

    groupTodo = Factory.create 'todo', todoUser,
      description: 'schedule group meeting'
      reference:
        id: -> group
        type: 'group'

    phoneCallTodo = Factory.create 'todo', todoUser,
      description: 'product discussion'
      reference:
        id: -> phone_call
        type: 'phone_call'

    smsTodo = Factory.create 'todo', todoUser,
      description: 'product discussion'
      reference:
        id: -> sms
        type: 'sms'

    todoTodo = Factory.create 'todo', todoUser,
      description: 'inception'
      reference:
        id: -> todo
        type: 'todo'

    callRalph = Factory.create 'todo', todoUser,
      description: 'call ralph'
      kind: 'call'
      reference:
        id: -> ralph
        type: 'contact'

    finishByTomrrow = Factory.create 'todo', todoUser,
      description: 'buy office equipment'
      finish_by: Ember.DateTime.create().advance(day: 1).toFullFormat()

    reminder = Factory.create 'reminder'

    Factory.create 'reminder',
      reference:
        id: -> Factory.build 'meeting'
        type: 'meeting'

    message = Factory.create 'message',
      type: 'email'

    feed_section = Factory.create 'feed_section'

    Radium.Gap.FIXTURES = []
    FixtureCreator.isInitialised = true

Radium.FixtureCreator = FixtureCreator

Ember.Application.registerInjection
  name: 'populate'
  after: 'foundry'
  injection: (app, router, property) ->
    FixtureCreator.populate() unless FixtureCreator.isInitialised


