require 'radium/mixins/filtered_collection_mixin'
require 'radium/views/feed/feed_item_container_view'

Radium.FeedItemsListView = Em.CollectionView.extend Radium.FilteredCollectionMixin,
  itemViewClass: Radium.FeedItemContainerView
