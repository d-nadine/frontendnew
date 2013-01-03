defaultTimeout = 3000

window.wait = (timeout, callback) ->
  timeout ||= defaultTimeout

  stop()
  setTimeout((->
    start()
    callback()
  ), timeout)

window.waitFor = (condition, callback, message) ->
  stop()

  message ||= 'waitFor timed out'

  startedAt = new Date().getTime()

  checkCondition = ->
    delta = new Date().getTime() - startedAt
    if delta > defaultTimeout
      start()
      throw new Error(message)
    else
      if condition()
        start()
        callback()
      else
        setTimeout(checkCondition, 20)

  checkCondition()

window.waitForSelector = (selector, callback, message) ->
  message ||= "'#{selector}' present"
  selector = [selector] unless $.isArray(selector)
  condition = -> $F.apply($F, selector).length

  callbackWithElement = ->
    # don't ask me why, but such additional short timeout fixes some
    # of the tests cases where there are problems with callbacks,
    # it may be related to animations or Ember.bindings
    wait 10, ->
      callback($F.apply($F, selector))

  waitFor condition, callbackWithElement, message

window.domClass = (model) ->
  id = model.get('id')
  type = model.constructor
  selector = ".#{type.toString().split('.').pop().underscore()}_#{id}"

window.waitForResource = (resource, callback, message) ->
  selector = domClass(resource)
  message ||= "#{selector} on page"

  waitForSelector selector, callback, message

window.waitForFeedItem = (resource, callback, message) ->
  selector = "#feed #{domClass(resource)}"

  callbackWithFeedItem = (feedItem) ->
    callback(feedItem.parent())

  waitForSelector selector, callbackWithFeedItem, message
