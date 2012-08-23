casper.start 'http://localhost:7777/'

casper.test.comment 'Todo should be commited after changing state'

casper.waitForSelector '.feed-section:first-child .todo:first-child', ->

  @evaluate (state) ->
    todo = Radium.store.find(Radium.Todo, 1)
    document.wasSaved = false
    statesInspector = ->
      if todo.get('isSaving')
        document.wasSaved = true
        todo.removeObserver('isSaving', statesInspector)

    todo.addObserver('isSaving', statesInspector)

  @click('.feed-section:first-child .todo:first-child input[type=checkbox]')

  @waitFor ->
    @evaluate ->
      document.wasSaved && jQuery('.feed-section:first-child .todo.finished:first-child').length != 0
  , ->
    casper.test.assertSelectorExists '.feed-section:first-child .todo.finished'

casper.run ->
  @test.done()
