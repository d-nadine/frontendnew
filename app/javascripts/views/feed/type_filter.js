Radium.FeedFilterView = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: 'nav nav-tabs nav-stacked'.w(),
  templateName: 'type_filters',
  itemViewClass: Ember.View.extend({
    tagName: 'li',
    templateName: 'type_filters',
    classNameBindings: ['isSelected:active'],
    isSelected: function() {
      return (this.getPath('parentView.filter') == this.getPath('content.kind')) ? true : false;
    }.property('parentView.filter').cacheable(),
    setFilter: function(event) {
      var kind = this.getPath('content.kind');
      this.setPath('parentView.filter', kind);
      return false;
    }
  })
});