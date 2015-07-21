# Depends on jScrollPane (http://jscrollpane.kelvinluck.com/)
# Only available for vertical scrolling

Radium.ScrollableMixin = Em.Mixin.create
  classNames: ['scroll-pane']
  scrollbarResizeTimer: null
  isAtBottom: false
  isAtTop: false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    p @constructor.toString()
    return if @get('noscroll')

    $(window).on 'resize.jscrollpane', @_resize.bind(this)
    dimensions = @getDimensions.bind(this)()

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

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    return if @get('noscroll')
    @$().data('jsp').destroy()
    $(window).off 'resize.jscrollpane'

  getDimensions: ->
    $this = @$()
    return unless $this
    parent = $this.parent()

    top = if parent.css('top') == 'auto'
            $('.sidebar').css('top')
          else
            $('.xdrawer-component').css('top')
    offset = parseFloat(top)
    height = $(window).height() - offset
    width = $this.innerWidth()
    dimensions =
      width: width
      height: height

  # Event handler for scrolling on Y axis, dispatches to public hooks
  didScrollHandler: (event, scrollPositionY, isAtTop, isAtBottom) ->
    @set('isAtBottom', isAtBottom)
    @set('isAtTop', isAtTop)

  _resize: ->
    return unless @$()
    Ember.run.next =>
      dimensions = @getDimensions()
      @$().height(dimensions.height)
