Radium.RegularInfinitescrollerComponent = Radium.InfiniteScrollerComponent.extend
  setupInfiniteScrollingListener: ->
    $(window).on 'scroll', @didScroll.bind(this)

  isScrolledToTheBottom: ->
    return if @dontScroll()
    distanceToViewportTop = ($(document).height() - $(window).height())
    viewPortTop = $(document).scrollTop()

    return false if viewPortTop == 0

    difference = (viewPortTop - distanceToViewportTop)

    return true if difference > 0 && difference < 5
