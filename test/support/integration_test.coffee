window.app = (code) ->
  $W.Ember.run code

window.integrationTest = (testName, expected, callback) ->
  if arguments.length == 2
    callback = expected
    expected = null

  oldApp = window.Radium
  oldFactory = window.Factory

  func = ->
    document.getElementById('app').onload = ->
      window.$W = document.getElementById('app').contentWindow

      window.$F = $W.$
      window.Radium = $W.Radium
      window.Factory = $W.Factory

      Radium.initialize()

      Radium.didBecomeCompletelyReady = ->
        callback()

        window.Radium = oldApp
        window.Factory = oldFactory

        clearTimeout(timer)

        start()

    stop()

    document.getElementById('app').contentWindow.location.reload()

    timer = setTimeout((->
      ok false, "Integration test timed out"
      start()
    ), 2000)

  QUnit.test testName, expected, func, false
