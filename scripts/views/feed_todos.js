define('views/feed_todos', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/feed_todos.handlebars');

  Radium.FeedTodosView = Ember.View.extend({
    classNames: 'feed-item todo'.w(),
    isVisible: function() {
      return this.getPath('parentView.isDetailsVisible');
    }.property('parentView.isDetailsVisible'),
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});