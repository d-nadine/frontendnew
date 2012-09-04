Radium.FeedItemContainerView = Em.ContainerView.extend
  classNames: ['feed-item-container', 'row']
  classNameBindings: ['expanded']

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

      # TODO: is there a better way to wait for loaded record before setting up template?
      observeTemplateName: (->
        type = @get('content.type')

        referenceType = @get('content.referenceType')
        referenceString = (if referenceType? then "_#{referenceType}" else '')
        @set('templateName', "feed_#{type}#{referenceString}")
        @rerender()
      ).observes('content.referenceType')

    @set 'currentView', view

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
