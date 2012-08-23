Radium.FeedItemContainerView = Em.ContainerView.extend
  classNames: ['feed-item-container', 'row']
  classNameBindings: ['expanded']
  type: (->
    if content = @get('content')
      content.contructor
  ).property('content')
  init: ->
    @_super.apply(this, arguments)

    feedDetailsContainer = Radium.FeedDetailsContainerView.create
      typeBinding: 'parentView.type'

    @set 'feedDetailsContainer', feedDetailsContainer

    type = @get('content.type')

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
        @set('templateName', "feed_#{type}")

    @set 'currentView', view

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
