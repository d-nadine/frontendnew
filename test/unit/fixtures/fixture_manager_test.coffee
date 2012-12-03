module 'FixtureManager',
  setup: ->
    Factory.define 'Core',
      abstract: true
      defaults:
        created_at: '2012-08-14T18:27:32Z'
        updated_at: '2012-08-14T18:27:32Z'

    Factory.define 'Todo',
      parent: 'Core'
      defaults:
        id: '66666'
        user_id: 1
        kind: 'general'
        description: 'Finish first product draft'
        finish_by: '2012-08-14T22:00:00Z'
        finished: false
        calendar_time: '2012-08-14T22:00:00Z'
        overdue: false
        comment_ids: [1]

    Factory.build 'Todo', 'overdue',
      id: '8888'
      description: 'Prepare product presentation'
      overdue: true

    Factory.define 'Meeting',
      parent: 'Core'
      defaults:
        id: '77777'
        user_id: 2
        user_ids: [1, 2]
        starts_at: '2012-08-17T18:27:32Z'
        ends_at: '2012-08-18T18:27:32Z'
        topic: 'Product discussion'
        location: 'Radium HQ'

    Radium.store = Radium.Store.create()

  teardown: ->
    if Radium.store
      Radium.store.destroy()

test 'should create todo factory', ->
  ok Factory.todos.default, 'precond - default todo in factory'
  ok Factory.todos.overdue, 'precond - overdue todo in factory'
  ok Factory.meetings.default, 'precond - default meeting in factory'

  todo =  Radium.Todo.find(66666)
  overdue = Radium.Todo.find(8888)
  meeting = Radium.Meeting.find(77777)

  equal false, todo.get('isLoaded')
  equal false, meeting.get('isLoaded')

  FixtureManager.loadAll(now: true)

  todo =  Radium.Todo.find(66666)
  overdue = Radium.Todo.find(8888)
  meeting = Radium.Meeting.find(77777)

  ok todo.get('isLoaded'), 'todo is loaded'
  ok overdue.get('isLoaded'), 'overdue is loaded'
  ok meeting.get('isLoaded'), 'meetings is loaded'
