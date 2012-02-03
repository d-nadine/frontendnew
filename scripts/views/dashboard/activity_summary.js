define(function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/dashboard/activity_summary.handlebars');
  require('views/feed_todos');

  Radium.ActivitySummaryView = Ember.View.extend({
    classNames: 'row feed-item'.w(),
    template: Ember.Handlebars.compile('{{view summaryBox}} {{view detailsView}}'),
    isDetailsVisible: false,
    detailsView: Radium.FeedTodosView,
    summaryBox: Ember.View.extend({
      classNames: 'span12'.w(),
      actionsVisible: false,
      click: function(evt) {
        // var p = this.getPath('parentView.isDetailsVisible');
        this.get('parentView').toggleProperty('isDetailsVisible');
      },
      template: Ember.Handlebars.compile(template)
    })
  });

  return Radium;
});