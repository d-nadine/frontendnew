Radium.FeedController = Em.ArrayController.extend
  sortAscending: false
  sortProperties: ['id']
  canScroll: true
  isLoading: false

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
