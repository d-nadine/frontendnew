defaultTimeout = 2000

window.waitFor = (condition, callback, message) ->
  message ||= 'waitFor timed out'
  finished = false
  timedOut = false

  timeout = ->
    unless finished
      timedOut = true
      ok false, message
      start()

  setTimeout timeout, defaultTimeout

  checkCondition = ->
    return if timedOut

    if condition()
      finished = true
      callback()
      start()
    else
      setTimeout(checkCondition, 20)

  stop()
  checkCondition()

window.waitForSelector = (selector, callback) ->
  condition = -> $(selector).length

  waitFor condition, callback, "Waiting for '#{selector}' timed out"
