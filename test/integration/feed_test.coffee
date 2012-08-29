test 'feed sections with dates should be displayed', ->
  expect(1)

  section = Radium.store.find(Radium.FeedSection, '2012-08-14')

  waitForResource section, ->
    headers = $('#feed .page-header h3')
    assertContains headers, 'Friday, August 17, 2012.*Tuesday, August 14, 2012'

test 'feed sections should contain todo items', ->
  expect(1)

  todo = F.todos('default')

  waitForResource todo, (el) ->
    assertContains el, 'Finish first product draft'
