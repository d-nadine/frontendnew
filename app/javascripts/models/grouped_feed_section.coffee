Radium.GroupedFeedSection = Radium.Core.extend
  init: ->
    @_super.apply this, arguments

    @set 'proxies', Ember.A([])

  bootstrapDates: (->
    date    = @get 'date'
    endDate = @get 'endDate'
    dates   = []

    if date && endDate
      date    = Ember.DateTime.parse date, '%Y-%m-%d'
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

    self = this
    @get('sections').forEach (section, i) ->
      items = section.get('items')

      self.addItemsProxy items
      collection.pushObjects items

    collection
  ).property()

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
