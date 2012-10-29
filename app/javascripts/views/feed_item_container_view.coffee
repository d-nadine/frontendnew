Radium.FeedItemContainerView = Em.ContainerView.extend
  classNames: ['feed-item-container', 'row']
  classNameBindings: ['expanded']

  expandedItemBinding: 'controller.expandedItem'

  init: ->
    @_super.apply(this, arguments)

    type = @get('content.type')

    feedDetailsContainer = Radium.FeedDetailsContainerView.create
      type: type

    @set 'feedDetailsContainer', feedDetailsContainer

    mixin = if type == 'todo'
      Radium.TodoViewMixin
    else
      Radium.Noop

    view = Radium.FeedItemView.create mixin,
      contentBinding: 'parentView.content'
      # TODO: most views from older client assume that content is also context,
      #       I'm doing it here too, but I'm not sure if this is the best thing
      #       to do, it needs to be revised later
      contextBinding: 'content'
      init: ->
        @_super.apply(this, arguments)

      didInsertElement: ->
        @set 'insertedElement', true

    observer = ->
      if @get('content.isLoaded')
        referenceType = @get('content.referenceType')
        type = @get('content.type')

        referenceString = (if referenceType? then "_#{referenceType}" else '')
        view.set('templateName', "feed_#{type}#{referenceString}")
        @set 'currentView', view

        @removeObserver('content.isLoaded', observer)

    if @get('content.isLoaded')
      observer.apply this
    else
      @addObserver('content.isLoaded', observer)

    @expandedItemDidChange()

  toggleTodoForm: ->
    feedDetailsContainer = @get('feedDetailsContainer')

    if feedDetailsContainer.get 'currentView'
      feedDetailsContainer.set 'currentView', null
    else
      todoFormView = Radium.TodoFormView.create()
      todoFormView.set 'selection', @get('content')

      feedDetailsContainer.set 'currentView', todoFormView

  expandOrShrink: (->
    feedDetailsContainer = @get('feedDetailsContainer')
    childViews = @get('childViews')

    if @get('expanded')
      childViews.pushObject feedDetailsContainer
    else
      feedDetailsContainer.slideUp ->
        childViews.removeObject(feedDetailsContainer)
        feedDetailsContainer.set('currentView', null)
  ).observes('expanded')

  expandedItemDidChange: (->
    if @get('expandedItem') == @get('content') && @get('currentView.insertedElement')
      self = this
      Ember.run.next ->
        Radium.Utils.scroll self.get('currentView').$(), ->
          self.set 'expanded', true
          self.set 'expandedItem', null
          Ember.run.next ->
            self.get('controller').enableScroll()
  ).observes('expandedItem', 'currentView.insertedElement')
