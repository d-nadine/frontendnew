define(function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/dashboard/activity_summary.handlebars');
  require('views/feed_todos');

  Radium.ActivitySummaryView = Ember.View.extend({
    classNames: 'row feed-item'.w(),
    template: Ember.Handlebars.compile('{{view summaryBox}} {{view detailsView}}'),
    isDetailsVisible: false,
    detailsView: Radium.FeedTodosView,
    isVisible: function() {
      var filter = Radium.feedController.get('categoryFilter');
      return (this.get(filter) !== undefined || filter === 'everything') ? true : false;
    }.property('Radium.feedController.categoryFilter').cacheable(),
    summaryBox: Ember.View.extend({
      classNames: 'span9'.w(),
      actionsVisible: false,
      click: function(evt) {
        this.get('parentView').toggleProperty('isDetailsVisible');
      },
      template: Ember.Handlebars.compile(template)
    })
  });

  return Radium;
});