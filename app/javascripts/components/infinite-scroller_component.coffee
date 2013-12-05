Radium.InfiniteScrollerComponent = Ember.Component.extend
  didInsertElement: ->
    @_super.apply this, arguments
    @setupInfiniteScrollingListener()

  setupInfiniteScrollingListener: ->
    @addObserver 'isAtBottom', this, 'didScroll'

  willDestroyElement: ->
    @_super.apply this, arguments
    @removeObserver 'isAtBottom', this, 'didScroll'

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
