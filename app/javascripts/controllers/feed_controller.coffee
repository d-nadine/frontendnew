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
    date = item.get('finishBy').toFormattedString('%Y-%m-%d')
    section = @find (section) -> section.get('id') == date
    unless section
      # we don't want to commit sections, so just put them on separate
      # transaction
      transaction = Radium.store.transaction()
      section = transaction.createRecord Radium.FeedSection,
        id: date
        date: Ember.DateTime.parse(date, '%Y-%m-%d')

      Radium.FeedSection.fixLinks(section)

    section.pushItem(item)

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
