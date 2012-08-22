casper.start 'http://localhost:7777/'

casper.test.comment "Comments are displayed in item's details"

# TODO: it would be nice to come up with some abstractions for elements
casper.waitForSelector '.feed-section:first-child .todo:first-child', ->
  @click('.feed-section:first-child .todo:first-child')

  @waitForSelector '.feed-section:first-child .feed-item-container:first-child .comments', ->
    @test.assertTextExists 'I like product drafts'

casper.test.comment 'Comment can be added to feed item'

casper.then ->
  @evaluate ->
    event = jQuery.Event("keypress")
    event.keyCode = 13

    # TODO: find a nicer way to do this using casper's API
    textarea = $('.feed-section:first-child .feed-item-container:first-child textarea.new-comment')
    textarea.val('Nice!').change().trigger(event)

casper.waitForSelector '.feed-section:first-child .feed-item-container:first-child .comment:nth-of-type(2)', ->
  @test.assertTextExists 'Nice!'

  id = @evaluate ->
    Radium.store.find(Radium.Todo, 1).get('comments').objectAt(1).get('id')

  @test.assert(!!id, 'comment is persisted')

casper.run ->
  @test.done()
