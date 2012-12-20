window.assertFeedItems = (expected, message) ->
  message ||= "Correct # of Feed Items"
  equal $F(".feed-item").length, expected, message 

window.assertEmptyFeed = ->
  assertFeedItems 0, "Feed is empty"

window.assertText = (element, text, callback) ->
  elementText = element.text().replace(/[\n\s]+/g, ' ')

  r = new RegExp(text)

  if r.test(elementText)
    ok true, "\"#{element.text()}\" should say \"#{text}\""
  else
    ok false, """
      "#{text}" should exist in this html:
      #{element.html()}
    """
