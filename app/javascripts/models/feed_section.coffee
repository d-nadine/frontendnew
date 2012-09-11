Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  nextDate: DS.attr('string')
  previousDate: DS.attr('string')

  # We don't want to load nextSection just by accessing the property,
  # so we can't do simple store.find. This filter will be updated only
  # when new records will be loaded in some other place
  nextSectionFilter: (->
    nextDate = @get('nextDate')
    Radium.FeedSection.filter (data) -> nextDate == data.get('id')
  ).property('nextDate')

  nextSectionBinding: 'nextSectionFilter.firstObject'

  previousSectionFilter: (->
    previousDate = @get('previousDate')
    Radium.FeedSection.filter (data) -> previousDate == data.get('id')
  ).property('previousDate')

  # FIXME: simple binding like with nextSectionBinding gives maximum
  #        call stack exceeded, wtf?
  previousSection: (->
    @get('previousSectionFilter.firstObject')
  ).property('previousSectionFilter.firstObject')

  items: Radium.ExtendedRecordArray.attr(
    key: 'item_ids'
    mixins: [Radium.ClusteredRecordArray]
  )

  pushItem: (item) ->
    @get('items').pushObject(item) unless @contains(item)

  contains: (item) ->
    @get('items').contains(item)
