defaultTimeout = 2000

window.wait = (timeout, callback) ->
  timeout ?= 2000
  stop()
  setTimeout( (->
    start()
    callback()
  ), timeout)


window.waitFor = (condition, callback, message) ->
  message ?= 'waitFor timed out'

  startedAt = new Date().getTime()

  stop()

  checkCondition = ->
    delta = new Date().getTime() - startedAt
    if delta > defaultTimeout
      ok false, message
    else
      if condition()
        start()
        callback()
      else
        setTimeout(checkCondition, 20)

  checkCondition()

window.waitForSelector = (selector, callback, message) ->
  selector = [selector] unless $.isArray(selector)
  condition = -> $.apply($, selector).length
  message ?= "Waiting for '#{selector}' timed out"

  callbackWithElement = ->
    # don't ask me why, but such additional short timeout fixes some
    # of the tests cases where there are problems with callbacks,
    # it may be related to animations or Ember.bindings
    wait 10, ->
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
  elementText = element.text().replace(/[\n\s]+/g, ' ')
  result = r.test elementText
  ok result, "Could not find '#{text}' inside #{elementText}"
