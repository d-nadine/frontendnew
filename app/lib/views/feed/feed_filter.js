Radium.FeedFilter = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: 'nav nav-tabs nav-stacked'.w(),
  itemViewClass: Ember.View.extend({
    categoryFilterBinding: 'Radium.dashboardController.categoryFilter',
    isEnabled: function() {
      return (this.get('categoryFilter') == this.getPath('content.shortname')) ? true : false;
    }.property('categoryFilter').cacheable(),
    classNameBindings: ['isEnabled:active'],
    templateName: 'feed_filter',
    changeFilter: function(event) {
      event.preventDefault();
      var type = this.getPath('content.shortname');
      Radium.dashboardController.set('categoryFilter', type);
      return false;
    },

    // The little + buttons
    addFormInlineView: Ember.View.extend({
      classNames: 'icon-plus',
      tagName: 'i',
      attributeBindings: ['title'],
      title: function() {
        var type = this.getPath('parentView.content.title');
        return "Add a new " + type.substr(0, type.length-1);
      }.property(),
      click: function(event) {
        var formType = this.getPath('parentView.content.formViewClass');
        Radium.App.send('loadForm', formType);
        event.stopPropagation();
        return false;
      }
    })
  })
});