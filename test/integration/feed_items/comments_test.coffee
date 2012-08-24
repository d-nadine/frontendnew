test "comments are displayed in item's details", ->
  todo = Radium.store.find(Radium.Todo, 1)

  waitForResource todo, (el) ->
    el.click()

    waitForSelector ['.comments', el], (comments)->
      assertContains comments, 'I like product drafts'

test 'comment can be added to feed item', ->
  event = jQuery.Event("keypress")
  event.keyCode = 13

  todo = Radium.store.find(Radium.Todo, 1)
  waitForResource todo, (el) ->
    el.click()

    waitForSelector ['.comments', el], (comments) ->
      # TODO: some abstraction for filling out such things would be cool
      textarea = $('.new-comment', comments)
      textarea.val('Nice!').change().trigger(event)

      comments = $('.comment', el)
      condition = -> comments.length == 2
      waitFor condition, ->
        assertContains comments, 'Nice!'

        #casper.waitForSelector '.feed-section:last-of-type .feed-item-container:first-of-type .comment:nth-of-type(2)', ->
        #  @test.assertTextExists 'Nice!'
        #
        #  id = @evaluate ->
        #    Radium.store.find(Radium.Todo, 1).get('comments').objectAt(1).get('id')
        #
        #  @test.assert(!!id, 'comment is persisted')
        #
        #casper.run ->
        #  @test.done()
