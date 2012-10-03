Radium.FeedController = Em.ArrayController.extend
  isFeedController: true
  canScroll: true
  isLoading: false

  currentDate: Ember.computed (key, value) ->
    if arguments.length == 2
      unless value.toFormattedString
        value = Ember.DateTime.parse(value, '%Y-%m-%d')

      @set('_currentDate', value)
      value
    else
      @get('_currentDate', value)

  currentDateDidChange: (->
    previousDate = @get('previousCurrentDate')
    currentDate  = @get('currentDate')

    if !previousDate || previousDate.toFormattedString('%Y-%m-%d') != currentDate.toFormattedString('%Y-%m-%d')
      Radium.get('router').send 'showDate', date: currentDate
  ).observes('currentDate')

  currentDateWillChange: (->
    @set 'previousCurrentDate', @get('currentDate')
  ).observesBefore('currentDate')

  showForm: (type) ->
    @set 'currentFormType', type

  isLoadingObserver: (->

    isLoading = @get 'content.isLoading'

    @set 'loadingAdditionalFeedItems', isLoading

    if isLoading
      @set 'isLoading', true
    else if !@get 'rendering'
      # stop loading only if rendering finished
      @set 'isLoading', false
  ).observes('content.isLoading', 'rendering')

  disableScroll: ->
    @set 'canScroll', false

  enableScroll: ->
    @set 'canScroll', true

  arrangedContent: (->
    if content = @get('content')
      range = @get('range')
      if range == 'daily'
        content
      else
        Radium.GroupedFeedSection.fromCollection content, range
  ).property('content', 'range')

  range: 'daily'

  pushItem: (item) ->
    self = this

    date = item.get('feedDate').toFormattedString('%Y-%m-%d')

    # check if there is a straight way between new section and the
    # first or last visible section
    first = @get 'firstObject'
    last  = @get 'lastObject'

    current   = null
    direction = null

    if first && date > first.get 'id'
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
      if !item.get('isNew')
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

  findRelatedSection: (other) ->
    @find (section) -> section.isRelatedTo other

  loadFeed: (options) ->
    return unless @get 'canScroll'

    # we want to adjust feed by manipulating scroll when
    # new items are laoded, but we want to do that *only*
    # in such situation, so let's annotate this fact with
    # this property:
    @set 'loadingAdditionalFeedItems', true

    date = null
    if options.forward
      item = @get('firstObject')
      if item
        date = item.get('nextDate')
    else if options.back
      item = @get('lastObject')
      if item
        date = item.get('previousDate')

    if date
      @get('content').loadRecord Radium.FeedSection.find(date)
    else
      range = @get('range')
      # if we get here, it means that we're not sure what the next/prev records are, so we
      # need to ask server, this is most of the time the case with specialized feed types
      if options.forward
        if item = @get('firstObject')
          if date = item.get('date')
            options =
              after: date.toFormattedString('%Y-%m-%d')
              limit: 1
              type: @get('type')
              id: @get('recordId')
              range: range

            if range != 'daily'
              options.after = item.get('endDate').toFormattedString('%Y-%m-%d')

            @get('content').load Radium.FeedSection.find(options)

      else if options.back
        if item = @get('lastObject')
          if date = item.get('date')
            options =
              before: date.toFormattedString('%Y-%m-%d')
              limit: 1
              type: @get('type')
              id: @get('recordId')
              range: range
            @get('content').load Radium.FeedSection.find(options)
