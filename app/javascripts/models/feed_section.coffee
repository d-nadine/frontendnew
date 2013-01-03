Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  nextDate: DS.attr('string')
  previousDate: DS.attr('string')

  isRelatedTo: (other) ->
    this == other

  # We don't want to load nextSection just by accessing the property,
  # so we can't do simple store.find. This filter will be updated only
  # when new records will be loaded in some other place
  nextSectionFilter: (->
    nextDate = @get('nextDate')
    Radium.FeedSection.filter (section) ->
      nextDate == section.get('id')
  ).property('nextDate')

  nextSection: (->
    @get('nextSectionFilter.firstObject')
  ).property('nextSectionFilter.firstObject')

  previousSectionFilter: (->
    previousDate = @get('previousDate')
    Radium.FeedSection.filter (data) -> previousDate == data.get('id')
  ).property('previousDate')

  # FIXME: simple binding like with nextSectionBinding gives maximum
  #        call stack exceeded, wtf?
  previousSection: (->
    @get('previousSectionFilter.firstObject')
  ).property('previousSectionFilter.firstObject')

  items: Radium.ExtendedRecordArray.attr('items', mixins: [Radium.ClusteredRecordArray])

  removeItem: (item) ->
    @get('items').removeObject item

  pushItem: (item) ->
    @get('items').pushObject item unless @contains(item)

  contains: (item) ->
    @get('items').contains item

  # And again, for some weird reason regular bindings does not
  # work as intended (probably they're not updated), check with
  # newer version
  clusters: (->
    @get 'items.clusters'
  ).property('items.clusters')

  unclustered: (->
    @get 'items.unclustered'
  ).property('items.unclustered')

  # Return true if section is before given date
  isBefore: (date) ->
    Ember.DateTime.compare(@get('date'), date) == -1

  # Return true if section is after given date
  isAfter: (date) ->
    Ember.DateTime.compare(@get('date'), date) == 1

  # checks if given date lays between this and otherSection
  # and if there is no gap between those sections
  dateBetween: (date, otherSection) ->
    unless date.advance
      date = Ember.DateTime.parse date, '%Y-%m-%d'

    ( @isBefore(date) && otherSection.isAfter(date) ) ||
       ( @isAfter(date) && otherSection.isBefore(date) ) &&
       ( @get('nextSection') == otherSection || @get('previousSection') == otherSection )

Radium.FeedSection.reopenClass
  loadSection: (store, date) ->
    store.load Radium.FeedSection,
      id: date.toDateFormat()
      date: date.toFullFormat()
      item_ids: []

