Radium.FeedHeaderView = Ember.View.extend({
  contentBinding: 'parentView.content',
  isActionsVisibleBinding: 'parentView.isActionsVisible',
  expandToggleIconView: Ember.View.extend({
    tagName: 'i',
    classNames: 'feed-expand-icon icon-plus'.w(),
    classNameBindings: ['parentView.isActionsVisible:icon-minus']
  }),
  iconView: Radium.SmallIconView.extend({
    contentBinding: Ember.Binding.or(
      'parentView.parentView.content',
      'parentView.content'
    ),
    classNames: 'pull-left activity-icon'.w()
  }),
  click: function() {
    this.toggleProperty('isActionsVisible');
  }
});
