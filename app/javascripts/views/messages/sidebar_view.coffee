Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  itemsDidChange: (->
    return unless @state is 'inDOM'
    Ember.run.scheduleOnce 'afterRender', this, 'shouldScroll'
  ).observes('controller.length')

  selectionDidChange: (->
    selectedItem = @get 'controller.selectedContent'
    return unless selectedItem

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToItem', selectedItem
  ).observes('controller.selectedContent')

  scrollToItem: (item) ->
    modelSelector = "[data-model='#{item.constructor}'][data-id='#{item.get('id')}']"
    element = Ember.$(modelSelector)

    return unless element.length

    position = element.offset().top
    scroller = @$('.scroller')

    boundingBoxTop = scroller.offset().top
    boundingBoxBottom = boundingBoxTop + scroller.outerHeight()

    return if position >= boundingBoxTop && position <= boundingBoxBottom

    outside = @$('.overview').position().top + @$('.scroller').offset().top
    distanceToCenter = outside + (0.5 * (@$('.scroller').height() - element.outerHeight()))
    distanceToElement = element.offset().top

    top = distanceToElement - distanceToCenter
    return if top < 0

    @get('scroller').tinyscrollbar_update top
