Radium.ClusterListView = Ember.CollectionView.extend Radium.FilteredCollectionMixin,
  classNames: ['feed-cluster-list']

  itemViewClass: Ember.ContainerView.extend
    childViews: []
    expandedItemBinding: 'controller.expandedItem'

    init: ->
      @_super.apply(this, arguments)
      @set 'currentView', Radium.ClusterItemView.create()
      @set 'feedItemsListView', Em.View.create Radium.Slider,
        templateName: 'radium/cluster_items_list'
        contentBinding: 'parentView.content'

        showMore: ->
          @get('content').showMore()

        showMoreLink: (->
          @get('content.length') < @get('content.totalLength')
        ).property('content.length', 'content.totalLength')

    expandOrShrink: (->
      childViews = @get('childViews')
      view       = @get('feedItemsListView')

      if @get('expanded')
        childViews.pushObject view
      else
        view.slideUp ->
          childViews.removeObject(view)
    ).observes('expanded')

    expandedItemDidChange: (->
      if @get('content').contains @get('expandedItem')
        @set 'expanded', true
    ).observes('expandedItem')
