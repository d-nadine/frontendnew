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

    date = null
    if options.forward
      item = @get('firstObject')
      if item
        date = item.get('nextDate')
    else if options.back
      item = @get('lastObject')
      console.log @get 'length'
      console.log 'item', item
      if item
        console.log item.get('previousDate')
        date = item.get('previousDate')

    if date
      @get('content').loadRecord Radium.store.find(Radium.FeedSection, date)
