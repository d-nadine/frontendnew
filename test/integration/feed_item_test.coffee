module 'Integration - Feed'

test 'adding a meeting shows it in the feed', ->
  expect(3)

  app -> Radium.reset()

  assertEmptyFeed()

  waitForSelector '.filters .add-meeting', (el) ->
    el.click()

    waitForSelector '#form-container', (el) ->
      meetingDate = Ember.DateTime.create().advance(day: 7)

      fillIn '#start-date', meetingDate.toDateFormat()
      fillIn '#description', 'New meeting'

      $('.btn-success').click()

      feedSelector = ".feed_section_#{meetingDate.toDateFormat()}"

      waitForSelector feedSelector, (el) ->
        wait 300, ->
          assertFeedItems(1)
          assertText el, 'New meeting'

test 'todos appear in the feed', ->
  #expect(4)

  app -> Radium.reset()

  assertEmptyFeed()

  section = Factory.create 'feed_section'
  todo = Factory.create 'todo',
          description: 'Finish programming radium'

  console.log 'TypeMap in test after create'
  console.log Radium.get('router.store').typeMapFor(Radium.Todo)

  Radium.Todo.find todo.get('id')

  console.log 'TypeMap in test after create and find again'
  console.log Radium.get('router.store').typeMapFor(Radium.Todo)

  ok todo.get('isLoaded'), "Todo must be loaded"

  console.log("Loaded state in test: #{todo.get('isLoaded')}")

  app -> 
    console.log("Pushing todo...")
    Radium.get('router.feedController').pushItem todo

  feedSelector = ".feed_section_#{section.get('id')}"

  waitForSelector feedSelector, (el) ->
    wait 300, ->
      assertFeedItems 1
      assertText el, 'Finish programming radium'
