test "comments are displayed in item's details", ->
  expect(1)
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    todo = F.todos('default')
    waitForResource todo, (el) ->
      el.click()

      waitForSelector ['.comments', el.parent()], (comments)->
        assertContains comments, 'I like product drafts'

test 'comment can be added to feed item', ->
  expect(2)
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    event = jQuery.Event("keypress")
    event.keyCode = 13

    todo = F.todos('default')
    waitForResource todo, (el) ->
      el.click()

      waitForSelector ['.comments', el.parent()], (commentsContainer) ->
        # TODO: some abstraction for filling out such things would be cool
        textarea = $('.new-comment', commentsContainer)
        ok textarea.length, "Comment box missing!"

        textarea.val('Nice!').change().trigger(event)

        comments = $('.comment', commentsContainer)
        condition = -> comments.length == 2

        waitFor condition, ->
          assertContains comments, 'Nice!'
