require 'radium/templates/feed'

Radium.FeedView = Em.View.extend Radium.InfiniteScroller,
  templateName: 'feed'
  elementId: 'feed'
  feedBinding: 'controller'

  empty: (->
    @get('feed.length') == 0 ||
      !@get('feed').find( (section) -> section.get('items.length') > 0 )
  ).property('feed', 'feed.@each.items.@each.length')

  emptyView: Em.View.extend
    templateName: 'empty_feed'

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
