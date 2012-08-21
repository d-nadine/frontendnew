Radium.FeedSectionsListView = Ember.CollectionView.extend
  itemViewClass: Em.View.extend
    classNames: ['feed-section']
  emptyView: Em.View.extend
    template: Em.Handlebars.compile('Nothing is here, you can add stuff')
