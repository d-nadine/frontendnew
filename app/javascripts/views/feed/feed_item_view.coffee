Radium.FeedItemView = Em.View.extend
  classNames: 'feed-header span9'.w()
  attributeBindings: ['title']
  layoutName: 'radium/layouts/feed_item'
  expandedBinding: 'parentView.expanded'

  click: (event) ->
    @toggleProperty('expanded')
