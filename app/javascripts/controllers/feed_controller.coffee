Radium.FeedController = Em.ArrayController.extend
  canScroll: true
  isLoading: false
  itemsLimit: 30

  scrollingPageSizeBinding: 'content.scrollingPageSize'

  # This property is used to scroll the feed. Set it
  # to an Ember.DateTime and the feed will adjust accordingly
  currentDate: undefined

  # Set this property to an item that can appear in the feed.
  # The feed will be loaded (if required).
  expandedItem: undefined

  # These methods are simple proxies to the underlying
  # Feed object. They are here only to help out
  loadFutureFeed: ->
    @get('content').loadFutureFeed()

  loadPastFeed: ->
    @get('content').loadPastFeed()

  pushObject: (item) ->
    @get('content').pushObject item

  showForm: (type) ->
    @set 'currentFormType', type

  isLoadingObserver: (->
    isLoading = @get 'content.isLoading'

    if isLoading
      @set 'isLoading', true
    else if !@get 'rendering'
      # stop loading only if rendering finished
      @set 'loadingAdditionalFeedItems', false
      @set 'isLoading', false
  ).observes('content.isLoading', 'rendering')

  disableScroll: ->
    @set 'canScroll', false

  enableScroll: ->
    @set 'canScroll', true

  currentDateDidChange: (->
    date = @get 'currentDate'
    @load nearDate: date, =>
      @set 'currentLoadedDate', date
  ).observes('currentDate')

  scrollForward: ->
    return unless @get 'canScroll'
    @loadFutureFeed()

  scrollBackward: ->
    return unless @get 'canScroll'
    @loadPastFeed()

  load: (query, callback) ->
    # we want to adjust feed by manipulating scroll when
    # new items are laoded, but we want to do that *only*
    # in such situation, so let's annotate this fact with
    # this property:
    @set 'loadingAdditionalFeedItems', true

    @get('content').load query, callback
