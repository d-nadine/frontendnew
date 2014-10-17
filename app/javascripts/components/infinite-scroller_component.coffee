Radium.InfiniteScrollerComponent = Ember.Component.extend
  setup: ( ->
    @setupInfiniteScrollingListener()
  ).on 'didInsertElement'

  setupInfiniteScrollingListener: ->
    @addObserver 'isAtBottom', this, 'didScroll'

  teardown: (->
    @removeObserver 'isAtBottom', this, 'didScroll'
  ).on 'willDestroyElement'

  didScroll: ->
    return unless @shouldLoadMore()

    @loadMore()

  loadMore: ->
    return if @get('isLoading')
    @sendAction 'getMore'

  dontScroll: ->
    @isDestroyed || @isDestroying || @get('allLoaded')

  shouldLoadMore: ->
    return if @dontScroll()

    @get('isAtBottom')
