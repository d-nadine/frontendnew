Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  nextDate: DS.attr('string')
  previousDate: DS.attr('string')
  items: Radium.ClusteredRecordArray.attr(key: 'item_ids')

  pushItem: (item) ->
    @get('items').pushObject(item) unless @contains(item)

  contains: (item) ->
    @get('items').contains(item)

Radium.FeedSection.reopenClass
  fixLinks: (section) ->
    sections = Radium.store.findAll(Radium.FeedSection)
    sections = sections.toArray().sort (a, b) -> if a.get('id') > b.get('id') then 1 else -1

    index = sections.indexOf(section)
    if previous = sections.objectAt(index - 1)
      previous.set 'nextDate', section.get('id')
      section.set 'previousDate',  previous.get('id')
    if next = sections.objectAt(index + 1)
      next.set 'previousDate', section.get('id')
      section.set 'nextDate', next.get('id')
