Radium.SCROLL_FORWARD = 1
Radium.SCROLL_BACK = 0

Radium.InfiniteScroller = Ember.Mixin.create
  didScroll: false

  init: ->
    @_super()
    $(window).on 'scroll', $.proxy(@onScroll, this)
    interval = setInterval $.proxy(@infiniteLoading, this), 300
    @set 'infiniteLoadingInterval', interval

  willDestroyElement: ->
    $(window).off 'scroll'
    clearInterval @get('infiniteLoadingInterval')

  # scroll event can fire handler a lot and also if request is fast,
  # it will result in weird bouncing. that's why it's best to limit
  # firing scroll handler, the actual handler is fired every 300ms and
  # checking for didScroll value
  onScroll: (e) ->
    @set 'didScroll', true
    false

  infiniteLoading: (e) ->
    return unless @get 'didScroll'

    isUp = @isUp()
    if isUp
      @set 'scrollDirection', Radium.SCROLL_FORWARD
    else
      @set 'scrollDirection', Radium.SCROLL_BACK

    if !isUp && ($(window).scrollTop() > $(document).height() - $(window).height() - 300)
      @get('controller').loadFeed back: true
    else if isUp && $(window).scrollTop() < 5
      @get('controller').loadFeed forward: true

    @set 'didScroll', false

  isUp: ->
    currentScrollTop = $(window).scrollTop()
    lastScrollTop = @get 'lastScrollTop'

    if !lastScrollTop?
      @set 'lastScrollTop', 0
      false
    else if currentScrollTop < 5
      @set 'lastScrollTop', 0
      true
    else
      isUp = currentScrollTop < @lastScrollTop
      @lastScrollTop = currentScrollTop
      isUp

  isLoadingObserver: (->
    $(window).off 'scroll'
    if @get('controller.isLoading')
      if @get('scrollDirection') is Radium.SCROLL_FORWARD
        @show(1)
      else
        @show(-1)
    else
      @hide()
      $(window).on 'scroll', $.proxy(@onScroll, this)
  ).observes('controller.isLoading')
