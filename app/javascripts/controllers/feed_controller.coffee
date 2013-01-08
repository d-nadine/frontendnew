Radium.FeedController = Em.ArrayController.extend
  isFeedController: true
  canScroll: true
  isLoading: false
  itemsLimit: 30

  # The number of items to load when the infinite scroller
  # fire
  scrollingPageSize: 1

  # This property is used to scroll the feed. Set it
  # to an Ember.DateTime and the feed will adjust accordingly
  currentDate: undefined

  # Set this property to an item that can appear in the feed.
  # The feed will be loaded (if required).
  expandedItem: undefined

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

  arrangedContent: (->
    if content = @get('content')
      content.limit 5

      range = @get('range')
      if range == 'daily'
        content
      else
        Radium.GroupedFeedSection.fromCollection content, range
  ).property('content', 'range')

  range: 'daily'

  commitTransaction: ->
    @get('store').commit()

  # TODO: this code will be removed
  createFeedItem: (type, item, ref) ->
    record = @get('store').createRecord type,  item
    record.set 'reference', ref if ref

    # TODO: feed sections could automatically handle adding
    # new items, but I'm not sure how would hat behave, it needs
    # a check with API or a lot of items
    @pushItem(record)

    @get('store').commit()

  pushItem: (item) ->
    self = this

    date = item.get('feedDate').toDateFormat()

    # check if there is a straight way between new section and the
    # first or last visible section
    first = @get 'firstObject'
    last  = @get 'lastObject'

    current   = null
    direction = null

    if !first && ! last # empty feed
      Radium.FeedSection.loadSection(@get('store'), item.get('feedDate'))
    else if first && date > first.get 'id'
      current   = first
      direction = 'next'
    else if last && date < last.get 'id'
      current   = last
      direction = 'previous'

    if current
      # this means that new section will be 'above' the first visible section
      loadSection = (current) ->
        nextDate = current.get "#{direction}Date"
        if nextDate == date
          true
        else if Radium.FeedSection.isInStore nextDate
          current = Radium.FeedSection.find nextDate
          self.get('content').loadRecord current

          loadSection current

      loadSection current

    # since we need to get feed section for given date from the API,
    # we need to be sure that item is already added to a server
    addItem = ->
      return if item.get('isNew')

      section = Radium.FeedSection.find date

      sections = self.get 'content'
      sections.loadRecord section

      section.pushItem(item)

      Radium.Utils.scrollWhenLoaded sections, item.get('domClass'), ->
        $(".#{item.get('domClass')}").effect("highlight", {}, 1000)

      item.removeObserver 'isNew', addItem

    if item.get('isNew')
      item.addObserver 'isNew', addItem
    else
      addItem()

  loadAfterSection: (section, limit) ->
    @get('content').load Radium.FeedSection.find
      after: section.get('id')
      limit: limit


  scrollForward: ->
    return unless @get 'canScroll'
    @loadFutureFeed()

  scrollBackward: ->
    return unless @get 'canScroll'
    @loadFutureFeed()

  loadFeed: (options) ->
    # we want to adjust feed by manipulating scroll when
    # new items are laoded, but we want to do that *only*
    # in such situation, so let's annotate this fact with
    # this property:
    @set 'loadingAdditionalFeedItems', true

    if options.forward
      @loadFutureFeed()
    else if options.back
      @loadPastFeed()

  loadFutureFeed: ->
    futureDate = @get 'nextFutureDate'
    return unless futureDate

    @load
      after: @get('nextFutureDate')
      limit: @get('scrollingPageSize')

  loadPastFeed: ->
    pastDate = @get 'nextPastDate'
    return unless pastDate

    @load
      before: @get('nextPastDate')
      limit: @get('scrollingPageSize')

  load: (query) ->
    query.scope = @get 'scope'

    results = Radium.FeedSection.find query
    @get('content').load results
