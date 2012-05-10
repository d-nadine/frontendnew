Radium.SmallIconView = Ember.View.extend({
  tagName: 'i',
  classNames: ['pull-left'],
  classNameBindings: [
    'todo:icon-check',
    'contact:icon-user',
    'email:icon-envelope'
  ],
  todo: function() {
    return this.getPath('parentView.content.kind') === 'todo';
  }.property('parentView.content.kind').cacheable(),
  contact: function() {
    return this.getPath('parentView.content.kind') === 'contact';
  }.property('parentView.content.kind').cacheable(),
  email: function() {
    return this.getPath('parentView.content.kind') === 'email';
  }.property('parentView.content.kind').cacheable(),
});