minispade.require('templates/dashboard/activity_summary');

Radium.ActivitySummaryView = Ember.View.extend({
  classNames: 'row feed-item'.w(),
  template: Ember.Handlebars.compile('{{view summaryBox}} {{view detailsView}}'),
  isDetailsVisible: false,
  detailsView: Radium.FeedTodosView,
  isVisible: function() {
    var filter = Radium.dashboardController.get('categoryFilter');
    return (this.get(filter) !== undefined || filter === 'everything') ? true : false;
  }.property('Radium.dashboardController.categoryFilter').cacheable(),
  summaryBox: Ember.View.extend({
    classNames: 'span9'.w(),
    actionsVisible: false,
    click: function(evt) {
      this.get('parentView').toggleProperty('isDetailsVisible');
    },
    templateName: 'activity_summary'
  })
});