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

Radium.GroupedFeedSection.reopenClass
  fromCollection: (collection, range) ->
    groups = []
    if range == 'weekly'
      weeks  = []
      collection.forEach (section) ->
        dayOfTheWeek = section.get('date').toFormattedString('%w')

        if dayOfTheWeek == '0'
          dayOfTheWeek = '7'

        dayOfTheWeek = parseInt dayOfTheWeek

        dayAdjustment = 1 - dayOfTheWeek
        startOfWeek  = section.get('date').advance(day: dayAdjustment)
        weeks.pushObject startOfWeek unless weeks.contains startOfWeek

      self = this
      weeks.forEach (startOfWeek) ->
        id ="#{ startOfWeek.toFormattedString('%Y-%m-%d') }-week"
        Radium.store.load self, id, {}
        group = self.find id
        group.setProperties
          date: startOfWeek
          endDate: startOfWeek.advance(day: 7)

        groups.pushObject group
    else if range == 'monthly'
      months = []
      collection.forEach (section) ->
        startOfMonth = section.get('date').adjust(day: 1)

        months.pushObject startOfMonth unless months.contains startOfMonth

      self = this
      months.forEach (startOfMonth) ->
        id ="#{ startOfMonth.toFormattedString('%Y-%m-%d') }-month"
        Radium.store.load self, id, {}
        group = self.find id
        group.setProperties
          date: startOfMonth
          endDate: startOfMonth.advance(month: 1).advance(day: -1)

        groups.pushObject group


    groups


