runWhenLoaded = (object, callback) ->
  if object.get('isLoaded')
    Ember.run.next ->
      callback.apply object
  else
    observer = ->
      callback.apply object
      object.removeObserver 'isLoaded', observer

    object.addObserver 'isLoaded', observer

# TODO: maybe it would be nice to handle queuing arrays added
#       with load. for now it's handled in router, but this
#       implementation is not bullet proof
# TODO: I built in sorting by id here, because SortableMixin is
#       harder to mix with other implementations and sections will
#       not change their ids anyway. It would be nice to move sorting
#       back to controller to keeps things nicely organized when
#       SortableMixin can play nicely with others (ie. when you
#       can overwrite arrangedContent to add filtering or something else)
UpdateableRecordArray = DS.RecordArray.extend
  isLoading: false

  loadRecord: (record) ->
    if record.get('isLoaded')
      @pushObject record
      return

    @set 'isLoading', true
    self = this

    runWhenLoaded record, ->
      self.pushObject record
      self.set 'isLoading', false

  load: (array) ->
    @set 'isLoading', true
    self = this

    runWhenLoaded array, ->
      @forEach (record) ->
        self.pushObject record

      self.set 'isLoading', false

  pushObject: (record) ->
    ids      = @get 'content'
    id       = record.get 'id'
    clientId = record.get 'clientId'

    return if ids.contains clientId

    index = @_binarySearch id, 0, ids.length
    ids.insertAt index, clientId

  limit: (limit) ->
    if content = @get 'content'
      if ( length = content.get('length') ) > limit
        content.replace(limit, length - limit)

  _binarySearch: (item, low, high) ->
    return low  if low is high
    mid = low + Math.floor((high - low) / 2)
    midClientId = @get('arrangedContent').objectAt(mid)
    midItem = @get('store').findByClientId(@get('type'), midClientId)
    if item < midItem.get('id')
      return @_binarySearch(item, mid + 1, high)
    else if item > midItem.get('id')
      return @_binarySearch(item, low, mid)
    mid

Radium.Feed = Ember.ArrayProxy.extend
  # Set this to a user/contact/group
  scope: undefined

  # The number of items to load when the infinite scroller
  # fire
  scrollingPageSize: 1

  content: (->
    result = Radium.FeedSection.find
      scope: @get('scope')
      nearDate: Ember.DateTime.create()

    recordArray = UpdateableRecordArray.create
      type: Radium.FeedSection
      content: Ember.A()
      store: Ember.get DS, 'defaultStore'

    recordArray.load result
    recordArray
  ).property('scope')

  # Overide push object to accept objects themselves
  # and not the encapsulated FeedSection. This also
  # handles more complex use cases. For example, pushing
  # a new item will ensure the entire day is loaded
  pushObject: (item) ->
    self = this
    date = item.get('feedDate')
    Ember.assert "Item does not have a feed date!" unless date

    # since we need to get feed section for given date from the API,
    # we need to be sure that item is already added to a server
    addItem = ->
      return if item.get('isNew')

      section = self.findDate date

      content = self.get 'content'
      content.loadRecord section

      section.pushItem(item)

      item.removeObserver 'isNew', addItem

    if item.get('isNew')
      item.addObserver 'isNew', addItem
    else
      addItem()

  nextPastDate: (->
    date = @get 'content.lastObject.previousDate'

    if date
      Ember.DateTime.parse "#{date}T00:00:00Z"
    else
      undefined
  ).property('content.lastObject')

  nextFutureDate: (->
    date = @get 'content.firstObject.nextDate'

    if date
      Ember.DateTime.parse "#{date}T00:00:00Z"
    else
      undefined
  ).property('content.firstObject')

  load: (query, callback) ->
    query.scope = @get 'scope'

    results = Radium.FeedSection.find query
    @get('content').load results

    runWhenLoaded results, callback if callback

  loadFutureFeed: ->
    futureDate = @get 'nextFutureDate'
    return unless futureDate

    @load
      after: futureDate
      limit: @get('scrollingPageSize')

  loadPastFeed: ->
    pastDate = @get 'nextPastDate'
    return unless pastDate

    @load
      before: pastDate
      limit: @get('scrollingPageSize')

  findDate: (date) ->
    Radium.FeedSection.find date.toDateFormat()
