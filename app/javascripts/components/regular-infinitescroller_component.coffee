require 'components/infinite-scroller_component'

Radium.RegularInfinitescrollerComponent = Radium.InfiniteScrollerComponent.extend
  setupInfiniteScrollingListener: ->
    $(window).on 'scroll.regularScroller', @didScroll.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    $(window).off 'scroll.regularScroller'

  shouldLoadMore: ->
    return if @dontScroll()
    distanceToViewportTop = ($(document).height() - $(window).height())
    viewPortTop = $(document).scrollTop()

    return false if viewPortTop == 0

    difference = (distanceToViewportTop - viewPortTop)

    return true if difference <= 0 && difference < 30
