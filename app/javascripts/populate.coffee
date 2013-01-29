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
      Factory.create 'email',
        sender: jerry

    group = Factory.create 'group',
      name: 'Product 1 group'

    developers = Factory.create 'group',
      name: 'Developers'

    phoneCall = Factory.create 'phone_call',
      to:  aaron
      from: ralph

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

    phoneCallTodo = Factory.create 'todo',
      user: jerry,
      description: 'product discussion'
      reference: phoneCall

    todoTodo = Factory.create 'todo',
      description: 'inception',
      user: jerry,
      reference: todo

    callRalph = Factory.create 'todo',
      description: 'call ralph',
      user: jerry,
      kind: 'call'
      reference: ralph

    finishByTomrrow = Factory.create 'todo',
      description: 'buy office equipment',
      user: jerry,
      finishBy: Ember.DateTime.create().advance(day: 1)

    Factory.create 'notification'
      reference: groupTodo
      tag: 'assigned.todo'

    Factory.create 'notification',
      reference: retrospection
      tag: 'invited.meeting'

Radium.Populator = Populator
