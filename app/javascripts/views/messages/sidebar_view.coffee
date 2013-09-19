Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  # FIXME: Need to review whether the tinyscrollbar is needed
  # itemsDidChange: (->
  #   return unless @state is 'inDOM'
  #   Ember.run.scheduleOnce 'afterRender', this, 'shouldScroll'
  # ).observes('controller.length')

  didInsertElement: ->
    @selectTab('folderTabView')
    @_super()

  folderTabSelected: (->
    @get('folderTabView').detectInstance(@.get('tabContentView.currentView'))
  ).property('tabContentView.currentView')
  radiumTabSelected: (->
    @get('radiumTabView').detectInstance(@.get('tabContentView.currentView'))
  ).property('tabContentView.currentView')
  searchTabSelected: (->
    @get('searchTabView').detectInstance(@.get('tabContentView.currentView'))
  ).property('tabContentView.currentView')

  selectTab: (tabName) ->
    @get('tabContentView').set('currentView', @get(tabName).create())

  folderTabView: Ember.View.extend
    templateName: 'messages/list'
  radiumTabView: Ember.View.extend
    templateName: 'messages/list'
  searchTabView: Ember.View.extend
    templateName: 'messages/search_form'

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
