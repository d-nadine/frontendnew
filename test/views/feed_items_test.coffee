view = null
store = null
fixtures = null

module "Feed items",
  setup: ->
    store = Radium.Store.create()
    fixtures = FixtureSet.create(store: store).loadAll(now: true)

  teardown: ->
    store.destroy()
    Ember.run ->
      view.remove()
    view = null

test 'todo item', ->
  item = fixtures.todos('default')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Finish first product draft'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo call item', ->
  item = fixtures.todos('call')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Call Ralph for discussing offer details'
  assertContains view.$('a'), 'Ralph'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo deal item', ->
  item = fixtures.todos('deal')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Great deal: Close the deal'
  assertContains view.$('a'), 'Great deal'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo campaign item', ->
  item = fixtures.todos('campaign')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Fall product campaign: Prepare campaign plan'
  assertContains view.$('a'), 'Fall product campaign'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo group item', ->
  item = fixtures.todos('group')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Product 1 group: schedule group meeting'
  assertContains view.$('a'), 'Product 1 group'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo phone call item', ->
  item = fixtures.todos('phone_call')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Call from Ralph to Jerry P.: product discussion'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo sms item', ->
  item = fixtures.todos('sms')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'SMS from Jerry P.: product discussion'
  assertContains view.$('a'), 'Jerry P'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo with todo item', ->
  item = fixtures.todos('with_todo')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'inception'
  assertContains view.$('a'), '(Aaron S.)'

test 'todo item', ->
  item = fixtures.todos('email')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Email from Jerry P.: write a nice response'
  assertContains view.$('a'), 'Jerry P.'
  assertContains view.$('a'), '(Aaron S.)'

test 'meeting item', ->
  item = fixtures.meetings('default')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Product discussion @ Radium HQ'

test 'deal item', ->
  item = fixtures.deals('default')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'pending Great deal'
  assertContains view.$('a'), '(Aaron S.)'

test 'call list item', ->
  item = fixtures.call_lists('default')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Call list'

test 'campaign item', ->
  item = fixtures.campaigns('default')

  Ember.run ->
    view = Radium.FeedItemContainerView.create(content: item)
    view.append()

  assertContains view.$(), 'Fall product campaign'
  assertContains view.$('a'), '(Aaron S.)'
