Radium.FeedItemView = Em.View.extend
  classNames: 'feed-header span9'.w()
  attributeBindings: ['title']
  classNameBindings: ['domClass']
  domClassBinding: 'content.domClass'
  titleBinding: Ember.Binding.oneWay('content.id')
  layoutName: 'feed_item_layout'
  expandedBinding: 'parentView.expanded'
  click: (event) ->
    @toggleProperty('expanded')
