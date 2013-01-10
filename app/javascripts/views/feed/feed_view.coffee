require 'radium/mixins/infinite_scroller'

Radium.FeedView = Em.View.extend Radium.InfiniteScroller,
  templateName: 'radium/feed'
  elementId: 'feed'
  feedBinding: 'controller'
  currentLoadedDateBinding: 'controller.currentLoadedDate'

  currentLoadedDateDidChange: (->
    date = @get('currentLoadedDate')
    return unless date

    # FIXME: this  needs to handle the case where the feed
    # is pushed down by another div
    Ember.run.next ->
      @$("[data-date=\"#{date.toDateFormat()}\"]").ScrollTo
        duration: 250
        offsetTop: 200

  ).observes('currentLoadedDate')

  # FIXME: this property is way to complicated
  empty: (->
    return true if @get('feed.length') == 0

    !@get('feed').find((section) -> section.get('items.length') > 0)
  ).property('feed', 'feed.@each.items.@each.length')

  emptyView: Em.View.extend
    templateName: 'radium/empty_feed'

  show: (direction) ->
    if view = @get('loadingView')
      view.show direction

  hide: (direction) ->
    if view = @get('loadingView')
      view.hide direction

  LoadingView: Ember.View.extend
    viewName: 'loadingView'
    elementId: 'mini-loader'
    classNames: 'alert alert-block'.w()
    didInsertElement: ->
      @$().hide()

    show: (dir) ->
      dir = 1
      # TODO: Remove once it's 100% confirmed the loading icon
      # is only to be visible from the top of the page.
      fromTop = top: 40
      fromBottom = bottom: -20
      fromTopLayout =
        bottom: 'auto'
        top: 0

      fromBottomLayout =
        bottom: -70
        top: 'auto'

      settings = (if (dir > -1) then fromTop else fromBottom)
      layout = (if (dir > -1) then fromTopLayout else fromBottomLayout)
      @set 'direction', dir
      @$().css(layout).show().animate settings, 500

    hide: (dir) ->
      dir = 1
      direction = @get('direction') or dir
      fromTop = top: -40
      fromBottom = bottom: -70
      settings = (if (direction > -1) then fromTop else fromBottom)
      @$().animate settings, 500, ->
        $(this).hide()

    template: Ember.Handlebars.compile('<h4 class=\'alert-heading\'>Loading &hellip;</h4>')
