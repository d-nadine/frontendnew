window.assertFeedItems = (expected, message) ->
  message ||= "Correct # of Feed Items"
  equal $F(".feed-item").length, expected, message 

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

  waitForSelector ".feed_section_#{dateToTestFor.toDateFormat()}", (el) ->
    assertText el, dateToTestFor.toFormattedString('%A, %B %D, %Y')

window.assertSelector = (selector, message) ->
  ok $F(selector).length > 0, "#{selector} exists"
