casper.start 'http://localhost:7777/'

casper.test.comment 'When all sections have no items, empty view should be displayed'

casper.waitForSelector '#feed', ->
  @evaluate ->
    Radium.store.findAll(Radium.FeedSection).forEach (s) -> s.set('itemIds', [])

  @waitFor ->
    @evaluate ->
      $('.feed-section:first-child .feed-item-container:first-of-type').length == 0
  , ->
    @test.assertTextExists 'Nothing here'

casper.run ->
  @test.done()
