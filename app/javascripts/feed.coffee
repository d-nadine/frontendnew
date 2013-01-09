require 'radium/lib/utils'
runWhenLoaded = Radium.Utils.runWhenLoaded
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

  findFor: (record) ->
    result = Radium.FeedSection.find
      scope: record
      nearDate: Ember.DateTime.create()

    recordArray = UpdateableRecordArray.create
      type: Radium.FeedSection
      content: Ember.A()
      store: Ember.get DS, 'defaultStore'

    recordArray.load result
    recordArray
