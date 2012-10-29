Radium.FeedItemView = Em.View.extend
  classNames: 'feed-header span9'.w()
  attributeBindings: ['title']
  classNameBindings: ['domClass']
  domClassBinding: 'content.domClass'
  titleBinding: Ember.Binding.oneWay('content.id')
  layoutName: 'radium/layouts/feed_item'
  expandedBinding: 'parentView.expanded'

  click: (event) ->
    @toggleProperty('expanded')

  toggleTodoForm: (e) ->
    e.stopPropagation()
    @get('parentView').toggleTodoForm()
