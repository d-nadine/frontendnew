Radium.InfiniteScrollerComponent = Ember.Component.extend
  isLoading: false
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

    @set 'isLoading', true

    Ember.run.debounce this, 'loadMore', 150

  loadMore: ->
    @sendAction 'getMore'
    @set 'isLoading', false

  isScrolledToTheBottom: ->
    viewportBottom = $('.viewport').offset().top + $('.viewport').height()

    thumbBottom = $('.thumb').offset().top + $('.thumb').height()

    ((Math.round(viewportBottom - thumbBottom)) == 0)
