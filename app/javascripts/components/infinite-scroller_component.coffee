Radium.InfiniteScrollerComponent = Ember.Component.extend
  didInsertElement: ->
    @_super.apply this, arguments
    @setupInfiniteScrollingListener()

  setupInfiniteScrollingListener: ->
    scroller = Ember.$('.sidebar .scroller')
    scroller.on 'mousewheel', @didScroll.bind(this)
    scroller.on 'DOMMouseScroll', @didScroll.bind(this)

  teardownInfiniteScrollingListener: ->
    scroller.off('mousewheel', @didScroll.bind(this))
    scroller.off('DOMMouseScroll', @didScroll.bind(this))

  didScroll: ->
    return unless @isScrolledToTheBottom()

    @loadMore()

  loadMore: ->
    return if @get('isLoading')
    @sendAction 'getMore'

  isScrolledToTheBottom: ->
    return if @isDestroyed || @isDestroying || @get('allLoaded')

    viewportBottom = $('.viewport').offset().top + $('.viewport').height()

    thumbTop = $('.thumb').offset().top

    thumbBottom = thumbTop  + $('.thumb').height()

    ((Math.round(viewportBottom - thumbBottom)) <= 30)
