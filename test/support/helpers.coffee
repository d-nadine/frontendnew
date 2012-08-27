defaultTimeout = 2000

window.waitFor = (condition, callback, message) ->
  message ?= 'waitFor timed out'
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
      start()
      callback()
    else
      setTimeout(checkCondition, 20)

  stop()
  checkCondition()

window.waitForSelector = (selector, callback, message) ->
  selector = [selector] unless $.isArray(selector)
  condition = -> $.apply($, selector).length
  message ?= "Waiting for '#{selector}' timed out"

  callbackWithElement = ->
    callback($.apply($, selector))

  waitFor condition, callbackWithElement, message

window.waitForResource = (resource, callback) ->
  id = resource.get('id')
  type = resource.constructor
  domClass = resource.get('domClass')
  selector = ".#{domClass}"

  waitForSelector selector, callback, "Could not find #{type} with id #{id} on the page"

window.elementFor = (resource) ->
  id = resource.get('id')
  type = resource.constructor
  domClass = resource.get('domClass')
  $(".#{domClass}")

window.assertContains = (element, text) ->
  throw "Element undefined" unless element
  throw "text is missing" unless element.text()

  r = new RegExp(text)
  result = r.test element.text()
  ok result, "Could not find '#{text}' inside #{element.text()}"
