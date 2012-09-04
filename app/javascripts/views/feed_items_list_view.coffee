Radium.FeedItemsListView = Em.CollectionView.extend
  # NOTE: it may be slow, investigate if there are problems with filtering
  content: (->
    if collection = @get('collection')
      if type = @get('controller.typeFilter')
        collection.filterProperty('type', type)
      else
        collection
  ).property('collection.@each.type', 'controller.typeFilter')
  itemViewClass: Radium.FeedItemContainerView
