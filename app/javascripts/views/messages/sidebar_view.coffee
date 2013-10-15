Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  didInsertElement: ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, 'fillSidebarWithMessages'

  fillSidebarWithMessages: ->
    messages = Ember.$('.sidebar').height() / 110
    if messages > 5
      @get('controller').send('showMore')
      Ember.$('.scroller').tinyscrollbar_update('relative')

  selectionDidChange: (->
    selectedItem = @get 'controller.selectedContent'
    return unless selectedItem

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToItem', selectedItem
  ).observes('controller.selectedContent')

  scrollToItem: (item) ->
    modelSelector = "[data-model='#{item.constructor}'][data-id='#{item.get('id')}']"
    # FIXME: do we need the tinyscrollbar?
    # element = Ember.$(modelSelector)

    # return unless element.length

    # position = element.offset().top
    # scroller = @$('.scroller')

    # boundingBoxTop = scroller.offset().top
    # boundingBoxBottom = boundingBoxTop + scroller.outerHeight()

    # return if position >= boundingBoxTop && position <= boundingBoxBottom

    # outside = @$('.overview').position().top + @$('.scroller').offset().top
    # distanceToCenter = outside + (0.5 * (@$('.scroller').height() - element.outerHeight()))
    # distanceToElement = element.offset().top

    # top = distanceToElement - distanceToCenter
    # return if top < 0

    # @get('scroller').tinyscrollbar_update top
