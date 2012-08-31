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

  loadFeed: (options) ->
    return unless @get 'canScroll'

    query = null
    item = null
    if options.forward
      item = @get('firstObject')
      if item
        query = { after: item }
    else if options.back
      item = @get('lastObject')
      if item
        query = { before: item }

    @get('content').load Radium.store.find(Radium.FeedSection, query)
