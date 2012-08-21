Radium.FeedActivityView = Em.ContainerView.extend
  init: ->
    @_super.apply(this, arguments)

    # for now we can just use statically created view, it will be needed to
    # extend it later to handle more types, not just todo
    view = Radium.FeedItemView.create Radium.TodoViewMixin,
      contentBinding: 'parentView.content'
      # TODO: most views from older client assume that content is also context,
      #       I'm doing it here too, but I'm not sure if this is the best thing
      #       to do, it needs to be revised later
      contextBinding: 'content'
      init: ->
        @_super.apply(this, arguments)
        @set('templateName', 'feed_todo')

    @set 'currentView', view
