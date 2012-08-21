Radium.FeedItemView = Em.View.extend
  classNames: 'feed-header span9'.w()
  attributeBindings: ['title']
  titleBinding: Ember.Binding.oneWay('content.id')
  layoutName: 'feed_item_layout'
