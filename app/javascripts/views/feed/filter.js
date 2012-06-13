/**
  Base Collection view for feed filtering.
*/
Radium.FeedFilterView = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: 'nav nav-tabs nav-stacked'.w(),
  templateName: 'filter'
});