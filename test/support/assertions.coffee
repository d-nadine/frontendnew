window.assertText = (element, text, callback) ->
  if element.text().indexOf(text) != -1
    ok true, "\"#{element.text()}\" should say \"#{text}\""
  else
    ok false, """
      "#{text}" should exist in this text:
      #{element.text()}
    """


window.assertSelector = (selector, message) ->
  ok $F(selector).length > 0, "#{selector} exists"

window.assertNotifications = (count) ->
  waitForSelector '.notifications-link', (link) ->
    equal link.text(), count.toString()

window.assertOnPage = (path) ->
  equal path, $W.Radium.get('router.currentPath')
