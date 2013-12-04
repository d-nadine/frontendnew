Radium.ScrollableMixin = Em.Mixin.create
  classNames: ['scroll-pane']
  scrollbarResizeTimer: null
  # didInsertElement: ->
  #   Ember.run.scheduleOnce('afterRender', @setupScollbar.bind(this))

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
  ).on('didInsertElement')

  _resize: ->
    dimensions = @getDimensions()
    @$()
      .height(dimensions.height)
      .data('jsp').reinitialise()