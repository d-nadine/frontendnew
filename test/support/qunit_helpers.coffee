window.integrationTest = (testName, expected, callback) ->
  if arguments.length == 2
    callback = expected
    expected = null

  func = ->
    document.getElementById('app').onload = ->
      window.$F = document.getElementById('app').contentWindow.jQuery
      window.$A = document.getElementById('app').contentWindow.Radium
      window.$W = document.getElementById('app').contentWindow

      $A.ready = ->
        callback()

        start()

    stop()

    $W.location.reload()

  QUnit.test( testName, expected, func, false )


