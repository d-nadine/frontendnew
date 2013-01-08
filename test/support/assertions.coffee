window.assertFeedItems = (expected, message) ->
  message ||= "Correct # of Feed Items"
  equal $F(".feed-item").length, expected, message 

window.assertClusters = (expected, message) ->
  message ||= "Correct # of clusters"
  equal $F(".cluster-item").length, expected, message 

window.assertEmptyFeed = ->
  assertFeedItems 0, "Feed is empty"

window.assertText = (element, text, callback) ->
  if element.text().indexOf(text) != -1
    ok true, "\"#{element.text()}\" should say \"#{text}\""
  else
    ok false, """
      "#{text}" should exist in this text:
      #{element.text()}
    """

window.clickFilterAndAssertFeedItems = (filterType, expected) ->
  clickFilter filterType, ->
    assertFeedItems expected, "#{expected} of #{filterType} expected"

window.assertScrollingFeedHasDate = (controller, daysToJump, direction) ->
  app ->
    controller.loadFeed direction
    controller.loadFeed direction

  dateToTestFor = Ember.DateTime.create().advance(day: daysToJump)

  waitForFeedDate dateToTestFor, ->
    ok true, "#{dateToTestFor.toDateFormat()} in feed"

window.assertSelector = (selector, message) ->
  ok $F(selector).length > 0, "#{selector} exists"

window.assertNotifications = (count) ->
  waitForSelector '.notifications-link', (link) ->
    equal link.text(), count.toString()

window.assertOnPage = (path) ->
  equal path, $W.Radium.get('router.currentPath')

window.assertInFeed = (item) ->
  selector = '[data-type="%@"][data-id="%@"]'.fmt item.get('constructor'), item.get('id')

  waitForSelector selector, ->
    ok true, "#{item.get('constructor')} #{item.get('id')} in feed"
