define(function(require) {

  var Radium = require('radium'),
      template = require('text!templates/feed_date_group.handlebars');

  Radium.FeedDateGroupView = Ember.View.extend({
    contentBinding: 'Radium.feedController.content',
    dateFilterBinding: 'Radium.feedController.dateFilter',
    template: Ember.Handlebars.compile(template)
  });

  return Radium;

});