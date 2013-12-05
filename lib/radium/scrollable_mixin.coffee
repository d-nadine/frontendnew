# Depends on jScrollPane (http://jscrollpane.kelvinluck.com/)
# Only available for vertical scrolling

Radium.ScrollableMixin = Em.Mixin.create
  classNames: ['scroll-pane']
  scrollbarResizeTimer: null
  isAtBottom: false
  isAtTop: false

  willDestroyElement: ->
    @$().data('jsp').destroy()

  getDimensions: ->
    $this = @$()
    height = $(window).height() - 60
    width = $this.innerWidth()
    dimensions =
      width: width
      height: height

  setupScollbar: (->
    $(window).on('resize.jscrollpane', @_resize.bind(this))
    dimensions = @getDimensions()

    @$()
      .height(dimensions.height)
      .jScrollPane(
        autoReinitialise: true
        verticalDragMaxWidth: 0
        verticalDragMinWidth: 0
        contentWidth: dimensions.width
        verticalGutter: 0
        horizontalGutter: 0
      )
      .on('jsp-scroll-y', @didScrollHandler.bind(this))
  ).on('didInsertElement')

  # Event handler for scrolling on Y axis, dispatches to public hooks
  didScrollHandler: (event, scrollPositionY, isAtTop, isAtBottom) ->
    @set('isAtBottom', isAtBottom)
    @set('isAtTop', isAtTop)

  _resize: ->
    dimensions = @getDimensions()
    @$()
      .height(dimensions.height)
      .data('jsp').reinitialise()
