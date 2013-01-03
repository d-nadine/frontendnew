window.click = (object) ->
  if object.hasOwnProperty 'click'
    object.click()
  else
    $F(object).click()

window.fillIn = (selector, text) ->
  # keyup with any char to trigger bindings sync
  event = jQuery.Event("keyup")
  event.keyCode = 46
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).val(text).trigger(event)

window.pressEnter = (selector) ->
  event = jQuery.Event("keypress")
  event.keyCode = 13
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).trigger(event)

window.fillInAndPressEnter = (selector, text) ->
  fillIn(selector, text)
  pressEnter(selector)

window.clickFilter = (feedType, callback) ->
  waitForSelector ".main-filter-item.#{feedType} a", (el) ->
    app ->
      click el

    callback()

window.clickFeedItem = (feedItem) ->
  $F(feedItem).find('.feed-header').click()

window.openNotifications = ->
  click '.notifications-link'
