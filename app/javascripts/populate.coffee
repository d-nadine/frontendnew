Number::randomize = ->
  Math.floor(Math.random() * this)

class Populator
  @run: ->
    settings = Factory.create 'settings'

    aaron = Factory.create 'user'
      name: 'Aaron Stephens'
      email: 'aaron.stephens13@radiumcrm.com'
      phone: '136127245078'

    jerry = Factory.create 'user'
      name: 'Jerry Parker'
      email: 'jerry.parker@radiumcrm.com'
      phone: '136127245071'

    ralph = Factory.create 'contact',
      name: 'Ralph'
      status: 'lead'

    john = Factory.create 'contact'
      name: 'John'
      status: 'lead'

    retrospection = Factory.create 'meeting',
      topic: 'Retrospection'
      location: 'Radium HQ'
      users:  [
        aaron,
        jerry
      ]

    retrospection = Factory.create 'meeting',
      topic: 'Retrospection'
      location: 'Radium HQ'
      users:  [
        aaron,
        jerry
      ]

    discussion1 = Factory.create 'discussion',
      topic: 'Discussion about the deal'
      users:  [
        aaron,
        jerry
      ]

    email = Factory.create 'email',
      subject: 'Subject of the email'
      sender: jerry

    email1 = Factory.create 'email',
      sender: aaron

    email2 = Factory.create 'email',
      sender: ralph

    email3 = Factory.create 'email',
      sender: john

    for i in [0..20]
      email = Factory.create 'email',
        sender: jerry

    group = Factory.create 'group',
      name: 'Product 1 group'

    developers = Factory.create 'group',
      name: 'Developers'

    deal = Factory.create 'deal',
      user: aaron

    todo = Factory.create 'todo',
      description: 'Finish first product draft',
      user: jerry

    overdue = Factory.create 'todo',
      description: 'Prepare product presentation',
      user: jerry
      overdue: true

    call = Factory.create 'todo',
      description: 'discussing offer details',
      finished: false,
      user: jerry,
      reference: ralph

    dealTodo = Factory.create 'todo',
      description: 'Close the deal',
      user: jerry,
      reference: deal

    emailTodo = Factory.create 'todo',
      description: 'write a nice response',
      user: jerry,
      reference: email

    groupTodo = Factory.create 'todo',
      description: 'schedule group meeting',
      user: jerry
      reference: group

    todoTodo = Factory.create 'todo',
      description: 'inception',
      user: jerry,
      reference: todo

    callRalph = Factory.create 'todo',
      description: 'call ralph',
      user: jerry,
      kind: 'call'
      reference: ralph

    finishByTomorrow = Factory.create 'todo',
      description: 'buy office equipment',
      user: jerry,
      finishBy: Ember.DateTime.create().advance(day: 1)

    Factory.create 'notification'
      reference: groupTodo
      tag: 'assigned.todo'

    Factory.create 'notification',
      reference: retrospection
      tag: 'invited.meeting'

    [0..50].forEach (num) ->
      users = [aaron, jerry]
      tasks = [emailTodo, todo]
      statuses = ['lead','negotiating','closed','lost']

      status = statuses[(4).randomize()]

      hash =
        status: status

      hash.user =  users[(2).randomize()]

      switch (3).randomize()
        when 0
          hash.todos = [todo]
          hash.nextTask = todo
        when 1
          hash.meetings = [retrospection]
          hash.nextTask = retrospection

      source = switch 5.randomize()
        when 0
          hash.source = "Lead form"
        when 1
          hash.source = "Marketing Convention"
        when 2
          hash.source = "Fake campaign"
        when 3
          hash.source = "Newsletter"

      hash.createdAt = Ember.DateTime.random(true)

      dealStatuses = ['published', 'closed', 'lost'].concat settings.get('negotiatingStatuses')

      hash.deals = ->
                    [
                      Factory.create 'deal',
                        user: -> users[(2).randomize()]
                        value: -> (10000).randomize()
                        reason: "something happened"
                        status: -> dealStatuses[(dealStatuses.length).randomize()]
                        payBy: -> Ember.DateTime.random()
                        contact: -> Radium.Contact.find().objectAt((Radium.Contact.find().get('length') - 1).randomize())
                        createdAt: -> Ember.DateTime.random(true)
                        todos: -> [todo] if hash.todos
                        meetings: -> [retrospection] if hash.meetings
                        lastStatus: -> dealStatuses[(3).randomize()]
                        nextTask: -> hash.nextTask if hash.nextTask
                    ]

      contact = Factory.create 'contact', hash

    # For the calendar
    # for i in [0..50]
    #   Factory.create 'todo'
    #     user: jerry
    #     finishBy: Ember.DateTime.random()

    #   Factory.create 'meeting'
    #     user: jerry
    #     startsAt: Ember.DateTime.random()

Radium.Populator = Populator
