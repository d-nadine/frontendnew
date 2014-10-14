Radium.RegularInfinitescrollerComponent = Radium.InfiniteScrollerComponent.extend
  setupInfiniteScrollingListener: ->
    $(window).on 'scroll.regularScroller', @didScroll.bind(this)

  teardown: ( ->
    $(window).off 'scroll.regularScroller'
  ).on 'willDestroyElement'

  isScrolledToTheBottom: ->
    return if @dontScroll()
    distanceToViewportTop = ($(document).height() - $(window).height())
    viewPortTop = $(document).scrollTop()

    return false if viewPortTop == 0

    difference = (viewPortTop - distanceToViewportTop)

    return true if difference > 0 && difference < 30
