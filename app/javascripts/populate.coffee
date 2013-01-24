class Populator
  @run: ->
    aaron = Factory.create 'user'
      name: 'Aaron Stephens'
      email: 'aaron.stephens13@radiumcrm.com'
      phone: '136127245078'

    jerry = Factory.create 'user'
      name: 'Jerry Parker'
      email: 'jerry.parker@radiumcrm.com'
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
      subject: 'Subject of the email'
      sender:
        id: -> jerry
        type: 'user'

    email1 = Factory.create 'email',
      sender:
        id: -> aaron
        type: 'user'

    email2 = Factory.create 'email',
      sender:
        id: -> ralph
        type: 'contact'

    email3 = Factory.create 'email',
      sender:
        id: -> john
        type: 'contact'

    for i in [0..20]
      Factory.create 'email',
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

Radium.Populator = Populator
