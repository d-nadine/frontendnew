app('/')

test 'groups collection automatically handles group management when sections are added', ->
  sections = Ember.A([])

  groups = Radium.GroupsCollection.create
    dependentContent: sections
    range: 'weekly'
    content: Ember.A([])

  s1 = F.feed_sections 'default'
  s2 = F.feed_sections 'feed_section_2012_08_17'
  s3 = F.feed_sections 'month_from_now'

  equal groups.get('length'), 0, 'initially groups are empty'

  sections.pushObject s1

  equal groups.get('length'), 1, 'group should be created when adding new item'

  sections.pushObject s2

  equal groups.get('length'), 1, 'groups should be unique, no need to create new group if it exists'

  group = groups.get('firstObject')

  equal group.get('date').toFormattedString('%Y-%m-%d'), '2012-08-13', ''
  equal group.get('endDate').toFormattedString('%Y-%m-%d'), '2012-08-19', ''

  sections.pushObject s3

  equal groups.get('length'), 2, 'new group is created'
