store = null
fixtures = null

module 'Radium.GroupedFeedSection'
  setup: ->
    store = Radium.Store.create()
    store.get('_adapter').set('simulateRemoteResponse', false)
    fixtures = FixtureSet.loadFixtures(['FeedSection', 'Deal', 'Todo', 'Meeting', 'CallList', 'Campaign'], store)
  teardown: ->
    store.destroy()

test 'clustered record array behaves as regular array when dealing with it', ->
  store.load Radium.GroupedFeedSection, 1, id: 1
  section = store.find Radium.GroupedFeedSection, 1

  s1 = fixtures.feed_sections 'default'
  s2 = fixtures.feed_sections 'feed_section_2012_08_17'

  section.set 'dates', [s1.get('id'), s2.get('id')]

  bothCount = s1.get('items.length') + s2.get('items.length')
  equal section.get('items.length'), bothCount, 'group should join items'
  equal section.get('items.clusters.length'), 1, 'clustering also works correctly'

  s1.pushItem fixtures.deals('big_contract')

  equal section.get('items.length'), bothCount + 1, 'group should be updated when sections are changed'

  s1.removeItem fixtures.deals('big_contract')

test 'grouped feed section correctly counts dates', ->
  store.load Radium.GroupedFeedSection, 1, id: 1
  section = store.find Radium.GroupedFeedSection, 1

  Ember.run ->
    section.setProperties
      date: '2012-10-10'
      endDate: '2012-10-15'

  dates = ['2012-10-10', '2012-10-11', '2012-10-12', '2012-10-13', '2012-10-14', '2012-10-15']
  deepEqual section.get('dates'), dates, ''
