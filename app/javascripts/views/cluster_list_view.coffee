Radium.ClusterListView = Ember.CollectionView.extend Radium.FilteredCollectionMixin,
  classNames: ['feed-cluster-list']

  itemViewClass: Ember.ContainerView.extend
    childViews: []

    init: ->
      @_super.apply(this, arguments)
      @set 'currentView', Radium.ClusterItemView.create()
      @set 'feedItemsListView', Em.View.create Radium.Slider,
        # TODO: I don't want to have different views for FeedItemsListView,
        #       but it seems there is no easy way to add collection view as
        #       as child of container view, check this.
        template: Em.Handlebars.compile('{{collection Radium.FeedItemsListView collectionBinding="view.parentView.content"}}')

    expandOrShrink: (->
      childViews = @get('childViews')
      view       = @get('feedItemsListView')

      if @get('expanded')
        childViews.pushObject view
      else
        view.slideUp ->
          childViews.removeObject(view)
    ).observes('expanded')
