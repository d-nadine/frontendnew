Radium.ClusterListView = Ember.CollectionView.extend
  classNames: ['feed-cluster-list']

  content: (->
    if collection = @get('collection')
      if type = @get('controller.typeFilter')
        collection.filter (object) ->
          # TODO: it could be unified with other filters, I think
          #       I will need to change type to something else
          #       ( get back to kind? )
          object.get('type') == Radium.Core.typeFromString(type)
      else
        collection
  ).property('collection.@each.type', 'controller.typeFilter')

  itemViewClass: Ember.ContainerView.extend
    childViews: []

    init: ->
      @_super.apply(this, arguments)
      @set 'currentView', Radium.ClusterItemView.create()
      @set 'feedItemsListView', Em.View.create Radium.Slider,
        # TODO: I don't want to have different views for FeedItemsListView,
        #       but it seems there is no easy way to add collection view as
        #       as child of container view, check this.
        template: Em.Handlebars.compile('{{collection Radium.FeedItemsListView contentBinding="view.parentView.content"}}')

    expandOrShrink: (->
      childViews = @get('childViews')
      view       = @get('feedItemsListView')

      if @get('expanded')
        childViews.pushObject view
      else
        view.slideUp ->
          childViews.removeObject(view)
    ).observes('expanded')
