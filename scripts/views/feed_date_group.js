define(function(require) {

  var Radium = require('radium');

  Radium.FeedDateGroupView = Ember.View.extend({
    contentBinding: 'Radium.feedController.content',
    items: function() {
      var content = this.get('content'),
          date = this.get('date');
          console.log(date.toString(), content.getEach('day'), content.filterProperty('year', date));
      return content.filterProperty('year', date.toString());
    }.property('date').cacheable()
  });

  return Radium;

});