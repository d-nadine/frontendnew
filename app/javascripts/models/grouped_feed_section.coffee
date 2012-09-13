Radium.GroupedFeedSection = Radium.Core.extend
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
        dates.pushObject date.toFormattedString('%Y-%m-%d')
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
    collection = Ember.ArrayProxy.create(
      Radium.ClusteredRecordArray, {
        store: Radium.store
        content: Radium.ExtendedRecordArray.create
          store: Radium.store,
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

    sections = Radium.store.expandableArrayFor Radium.FeedSection

    dates = dates.filter (date) ->
      # if section is already in store, let's just add it
      if Radium.FeedSection.isInStore date
        sections.loadRecord Radium.FeedSection.find(date)
        false
      else
        true

    # now, load the rest of the dates
    sections.load Radium.FeedSection.find(dates: dates)

    sections
  ).property()


Radium.GroupsCollection = Ember.ArrayProxy.extend
  init: ->
    @_super.apply this, arguments

    self = this
    dependentContent = @get 'dependentContent'
    dependentContent.forEach (section) ->
      self.pushSection section

    dependentContent.addArrayObserver this,
      didChange: 'dependentContentWillChange'
      willChange: 'dependentContentDidChange'

  pushSection: (section) ->
    group = @groupFor section
    group.get('sections').pushObject section

  groupFor: (section) ->
    range = @get('range')
    id    = null

    if range == 'weekly'
      dayOfTheWeek = section.get('date').toFormattedString('%w')

      if dayOfTheWeek == '0'
        dayOfTheWeek = '7'

      dayOfTheWeek = parseInt dayOfTheWeek

      dayAdjustment = 1 - dayOfTheWeek
      startOfWeek  = section.get('date').advance(day: dayAdjustment)

      id      = "#{ startOfWeek.toFormattedString('%Y-%m-%d') }-week"
      date    = startOfWeek
      endDate = date.advance day: 7

    else if range == 'monthly'
      startOfMonth = section.get('date').adjust(day: 1)

      id      = "#{ startOfMonth.toFormattedString('%Y-%m-%d') }-month"
      date    = startOfMonth
      endDate = date.advance(month: 1).advance(day: -1)

    group = null
    if Radium.GroupedFeedSection.isInStore id
      group = Radium.GroupedFeedSection.find id
    else
      Radium.store.load Radium.GroupedFeedSection, id, {}
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
