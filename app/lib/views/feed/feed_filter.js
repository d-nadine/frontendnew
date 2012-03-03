Radium.FeedFilterView = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: 'nav nav-tabs nav-stacked'.w(),
  itemViewClass: Ember.View.extend({
    isEnabled: function() {
      return (this.getPath('parentView.categoryFilter') === this.getPath('content.shortname')) ? true : false;
    }.property('parentView.categoryFilter').cacheable(),
    classNameBindings: ['isEnabled:active'],
    templateName: 'feed_filter',
    changeFilter: function(view, event, context) {
      var type = this.getPath('content.shortname');
      this.setPath('parentView.categoryFilter', type);
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
        Radium.App.send('addResource', formType);
        event.stopPropagation();
        return false;
      }
    }),

    // The badge count of leads
    badgeView: Ember.View.extend({
      tagName: 'span',
      classNames: 'label pull-right'.w(),
      count: function() {
        var type = this.getPath('parentView.content.shortname'),
            plural = (type === 'everything' || type === 'pipeline') ? 'content' : type+'s',
            activities = this.getPath('parentView.controller.'+plural);
        return activities.get('length');
      }.property(
        'parentView.controller.todos',
        'parentView.controller.meetings',
        'parentView.controller.deals',
        'parentView.controller.messages',
        'parentView.controller.phonecalls',
        'parentView.controller.discussions',
        'parentView.controller.pipeline'
      ).cacheable(),
      template: Ember.Handlebars.compile('{{count}}')
    })
  })
});