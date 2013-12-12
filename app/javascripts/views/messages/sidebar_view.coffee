Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  didInsertElement: ->
    @_super.apply this, arguments

  selectionDidChange: (->
    selectedItem = @get 'controller.selectedContent'
    return unless selectedItem

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToItem', selectedItem
  ).observes('controller.selectedContent')

  searchTextField: Ember.TextField.extend
    classNames: ['field']
    placeholderBinding: 'content.selectedSearchScope'
    valueBinding: 'targetObject.term'

    click: (event) ->
      event.stopPropagation()

    keyDown: (e) ->
      e.preventDefault() if e.keyCode is 13

    insertNewline: (e) ->
      @get('targetObject').send 'search'

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
