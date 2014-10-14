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
    return unless @isScrolledToTheBottom()

    @loadMore()

  loadMore: ->
    return if @get('isLoading')
    @sendAction 'getMore'

  dontScroll: ->
    @isDestroyed || @isDestroying || @get('allLoaded')

  isScrolledToTheBottom: ->
    return if @dontScroll()

    @get('isAtBottom')
