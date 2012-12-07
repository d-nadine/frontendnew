Radium.GroupedFeedSection = Radium.Core.extend
  isRelatedTo: (section) ->
    @get('sections').contains section

  clusters: (->
    @get 'items.clusters'
  ).property('items.clusters')

  unclustered: (->
    @get 'items.unclustered'
  ).property('items.unclustered')

  init: ->
    @_super.apply this, arguments

    @set 'proxies', Ember.A([])

  bootstrapDates: (->
    date    = @get 'date'
    endDate = @get 'endDate'
    dates   = []

    if date && endDate
      unless date.constructor == Ember.DateTime
        date    = Ember.DateTime.parse date, '%Y-%m-%d'
      unless endDate.constructor == Ember.DateTime
        endDate = Ember.DateTime.parse endDate, '%Y-%m-%d'

      while Ember.DateTime.compare(date, endDate) <= 0
        dates.pushObject date.toDateFormat()
        date = date.advance(day: 1)

      @set 'dates', dates
  ).observes('date', 'endDate')

  itemsProxy: Ember.ArrayProxy.extend
    contentArrayDidChange: (array, idx, removedCount, addedCount) ->
      items = @get('context.items')

      addedObjects = array.slice(idx, idx + addedCount)
      for object in addedObjects
        items.pushObject object unless items.contains object

      removedObjects = array.slice(idx, idx + removedCount)
      for object in removedObjects
        items.removeObject object

      @_super.apply(this, arguments)


  addItemsProxy: (items) ->
    proxies = @get 'proxies'
    proxy   = @get('itemsProxy').create
      content: items
      context: this

    proxies.pushObject proxy

  items: (->
    store = @get('store')

    collection = Ember.ArrayProxy.create(
      Radium.ClusteredRecordArray, {
        store: store
        content: Radium.ExtendedRecordArray.create
          store: store,
          content: Ember.A([])
      }
    )

    sections = @get('sections')

    @sectionsAdded collection, sections

    sections.addArrayObserver this,
      didChange: 'sectionsDidChange'
      willChange: 'sectionsWillChange'

    collection
  ).property()

  sectionsAdded: (collection, sections) ->
    self = this
    sections.forEach (section, i) ->
      items = section.get('items')

      self.addItemsProxy items
      collection.pushObjects items

  sectionsDidChange: (array, idx, removedCount, addedCount) ->
    items = @get 'items'

    sections = array.slice(idx, idx + addedCount)
    @sectionsAdded items, sections

  sectionsWillChange: ->

  sections: (->
    dates = @get('dates')
    store = @get('store')

    sections = store.expandableArrayFor Radium.FeedSection

    dates = dates.filter (date) ->
      # if section is already in store, let's just add it
      if Radium.FeedSection.isInStore date, store
        sections.loadRecord Radium.FeedSection.find(date)
        false
      else
        true

    # now, load the rest of the dates
    sections.load Radium.FeedSection.find(dates: dates)

    sections
  ).property()


# TODO: since ids will never change, we could not use SortableMixin, but
#       choose the right place when inserting object (just like in expandable
#       record array), maybe create a mixin for that and use in both places?
Radium.GroupsCollection = Ember.ArrayProxy.extend Ember.SortableMixin,
  sortProperties: ['id']
  sortAscending: false

  init: ->
    @_super.apply this, arguments

    self = this
    dependentContent = @get 'dependentContent'
    dependentContent.forEach (section) ->
      self.pushSection section

    dependentContent.addArrayObserver this,
      willChange: 'dependentContentWillChange'
      didChange: 'dependentContentDidChange'

  pushSection: (section) ->
    group = @groupFor section
    group.get('sections').pushObject section

  groupFor: (section) ->
    range = @get('range')
    id    = null
    [date, endDate] = Radium.Utils.rangeForDate(section.get('date'), range)

    if range == 'weekly'
      id      = "#{date.toDateFormat()}-week"
    else if range == 'monthly'
      id      = "#{date.toDateFormat()}-month"

    group = null
    if Radium.GroupedFeedSection.isInStore id, @get('store')
      group = Radium.GroupedFeedSection.find id
    else
      @get('store').load Radium.GroupedFeedSection, id, {id: id}
      group = Radium.GroupedFeedSection.find id
      group.setProperties
        date: date
        endDate: endDate

    content = @get 'content'
    content.pushObject group unless content.contains group

    group


  dependentContentWillChange: ->
    true

  dependentContentDidChange: (array, idx, removedCount, addedCount) ->
    addedSections = array.slice(idx, idx + addedCount)
    for section in addedSections
      @pushSection section

Radium.GroupedFeedSection.reopenClass
  fromCollection: (collection, range) ->
    Radium.GroupsCollection.create
      dependentContent: collection
      range: range
      content: Ember.A([])
