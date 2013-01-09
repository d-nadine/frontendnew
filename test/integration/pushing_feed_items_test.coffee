module 'Integration - Push Feed Items'

integrationTest 'adds an item when there is no existing feed items', ->
  assertEmptyFeed()

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.activeFeedController').pushObject(todo)

  assertInFeed todo 

integrationTest 'adds an item when there is an existing feed item', ->
  assertEmptyFeed()

  todo1 = Factory.create 'todo'
  todo2 = Factory.create 'todo'

  app ->
    Radium.get('router.activeFeedController').pushObject todo1
    Radium.get('router.activeFeedController').pushObject todo2

  assertInFeed todo1
  assertInFeed todo2 

integrationTest 'adds an item and checks for more feed items', ->
  assertEmptyFeed()

  nextWeek = Ember.DateTime.create().advance day: 7

  existingTodo = Factory.create 'todo', 
    description: 'Existing Todo'
    finish_by: nextWeek.toFullFormat()

  # Simulate a comlete feed section that would be available
  # via the API but is not yet loaded by theclient
  feedSection = {
    id: nextWeek.toDateFormat()
    date: nextWeek.toFullFormat()
    item_ids: [
      [Radium.Todo, existingTodo.get('id')]
    ]
  }

  Radium.FeedSection.FIXTURES.push feedSection

  newTodo = Factory.create 'todo',
    description: 'Added on the client'
    finish_by: nextWeek.toFullFormat()

  app ->
    Radium.get('router.activeFeedController').pushObject newTodo

  assertInFeed newTodo
  assertInFeed existingTodo
