Radium.InfiniteScrollerComponent = Ember.Component.extend
  setup: Ember.on 'didInsertElement', ->
    @setupInfiniteScrollingListener()

  setupInfiniteScrollingListener: ->
    @addObserver 'isAtBottom', this, 'didScroll'

  teardown: Ember.on 'willDestroyElement', ->
    @removeObserver 'isAtBottom', this, 'didScroll'

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
