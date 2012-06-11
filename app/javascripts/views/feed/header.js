Radium.FeedHeaderView = Ember.View.extend({
  contentBinding: 'parentView.content',
  classNames: 'feed-header span9'.w(),
  attributeBindings: ['title'],
  titleBinding: Ember.Binding.oneWay('content.id'),
  layoutName: 'historical_layout',
  isActionsVisibleBinding: 'parentView.isActionsVisible',
  click: function(event) {
    event.stopPropagation();
    this.toggleProperty('isActionsVisible');
  }
});