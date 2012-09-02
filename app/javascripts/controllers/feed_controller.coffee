Radium.FeedController = Em.ArrayController.extend
  sortAscending: false
  sortProperties: ['id']

  canScroll: true
  isLoading: false

  isLoadingObserver: (->
    if @get 'content.isLoading'
      @set 'isLoading', true
    else if !@get 'rendering'
      # stop loading only if rendering finished
      @set 'isLoading', false
  ).observes('content.isLoading', 'rendering')

  pushItem: (item) ->
    # since we need to get feed section for given date from the API,
    # we need to be sure that item is already added to a server
    self = this

    addItem = ->
      if !item.get('isNew')
        date = item.get('finishBy').toFormattedString('%Y-%m-%d')
        section = Radium.store.find Radium.FeedSection, date

        self.get('content').loadRecord section

        section.pushItem(item)

        item.removeObserver 'isNew', addItem

    if item.get('isNew')
      item.addObserver 'isNew', addItem
    else
      addItem()


  loadFeed: (options) ->
    return unless @get 'canScroll'

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
      @get('content').loadRecord Radium.store.find(Radium.FeedSection, date)
