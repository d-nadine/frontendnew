define(function(require) {

  var Radium = require('radium');

  Radium.FeedDateItemView = Ember.View.extend({
    dateGroup: function() {
      var content = this.getPath('parentView.content'),
          filter = this.getPath('parentView.dateFilter') || 'day',
          date = this.get('date');

      return content.filterProperty(filter, date.toString());
    }.property('date', 'parentView.dateFilter').cacheable()
  });

  return Radium;
});