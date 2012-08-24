casper.start 'http://localhost:7777/'

casper.test.comment 'Todo should be commited after changing state'

casper.waitForSelector '.feed-section:last-of-type .todo:first-of-type', ->

  @evaluate (state) ->
    todo = Radium.store.find(Radium.Todo, 1)
    document.wasSaved = false
    statesInspector = ->
      if todo.get('isSaving')
        document.wasSaved = true
        todo.removeObserver('isSaving', statesInspector)

    todo.addObserver('isSaving', statesInspector)

  @click('.feed-section:last-of-type .todo:first-of-type input[type=checkbox]')

  @waitFor ->
    @evaluate ->
      document.wasSaved && jQuery('.feed-section:last-of-type .todo.finished:first-of-type').length != 0
  , ->
    casper.test.assertSelectorExists '.feed-section:last-of-type .todo.finished'

casper.run ->
  @test.done()
