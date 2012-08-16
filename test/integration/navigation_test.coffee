casper.start 'http://localhost:7777/'

casper.waitForSelector '#feed', ->
  @test.assertSelectorExists('#feed', 'feed renders')

casper.run ->
  @test.done()
