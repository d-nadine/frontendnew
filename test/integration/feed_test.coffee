casper.start 'http://localhost:7777/'

casper.test.comment 'Feed sections with dates should be displayed'

casper.waitForSelector '.feed-section:first-child', ->
  @test.assertTextExists 'Tuesday, August 14, 2012'

casper.test.comment 'Feed sections should contain todo items'

casper.waitForSelector '.feed-section:first-child .todo:first-child', ->
  @test.assertTextExists 'Finish first product draft'

casper.run ->
  @test.done()
