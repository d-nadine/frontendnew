# we need bootstrapped store here
app '/'

module 'Radium.ContactFeedSection'

test 'it forwards delegates items to section', ->
  transaction = Radium.store.transaction()

  attrs = {
    section_id: '2012-01-01'
    record_id: 1
  }

  contact = F.contacts('ralph')

  Radium.store.load(Radium.FeedSection, '2012-01-01', { item_ids: [] })
  # TODO: extract this into fixtures to load it with one line
  Radium.store.load(Radium.ContactFeedSection, '2012-01-01#1', attrs)

  section = Radium.FeedSection.find('2012-01-01')
  contact_section = Radium.ContactFeedSection.find('2012-01-01#1')

  todos = []

  equal contact_section.get('items.clusters.length'), 0, ''
  equal contact_section.get('items.unclustered.length'), 0, ''

  # check if adding new items to section will change contact section
  section.pushItem F.todos('call')

  equal contact_section.get('items.clusters.length'), 0, 'record added to section should populate contact section'
  equal contact_section.get('items.unclustered.length'), 1, ''

  for i in [1..6]
    Radium.store.load Radium.Todo, i + 1000,
      id: i + 1000
      reference:
        id:   1
        type: 'contact'

    todo = Radium.Todo.find i + 1000
    section.pushItem todo

  equal contact_section.get('items.clusters.length'), 1, 'contacts section items should be properly clustered'
  equal contact_section.get('items.unclustered.length'), 0, ''
