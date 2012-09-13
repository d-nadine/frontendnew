# TODO: I should not load app for unit tests...
app('/')

test 'clustered record array behaves as regular array when dealing with it', ->
  Radium.store.load Radium.GroupedFeedSection, 1, id: 1
  section = Radium.GroupedFeedSection.find 1

  s1 = F.feed_sections 'default'
  s2 = F.feed_sections 'feed_section_2012_08_17'

  section.set 'dates', [s1.get('id'), s2.get('id')]

  bothCount = s1.get('items.length') + s2.get('items.length')
  equal section.get('items.length'), bothCount, 'group should join items'
  equal section.get('items.clusters.length'), 1, 'clustering also works correctly'

  s1.pushItem F.deals('big_contract')

  equal section.get('items.length'), bothCount + 1, 'group should be updated when sections are changed'

  s1.removeItem F.deals('big_contract')

test 'grouped feed section correctly counts dates', ->
  Radium.store.load Radium.GroupedFeedSection, 1, id: 1
  section = Radium.GroupedFeedSection.find 1

  Ember.run ->
    section.setProperties
      date: '2012-10-10'
      endDate: '2012-10-15'

  dates = ['2012-10-10', '2012-10-11', '2012-10-12', '2012-10-13', '2012-10-14', '2012-10-15']
  deepEqual section.get('dates'), dates, ''
