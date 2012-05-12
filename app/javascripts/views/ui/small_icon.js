Radium.SmallIconView = Ember.View.extend({
  tagName: 'i',
  classNames: ['pull-left'],
  classNameBindings: [
    'todo:icon-check',
    'contact:icon-user',
    'email:icon-envelope'
  ],
  todo: function() {
    return this.getPath('content.kind') === 'todo';
  }.property('content.kind').cacheable(),
  contact: function() {
    return this.getPath('content.kind') === 'contact';
  }.property('content.kind').cacheable(),
  email: function() {
    return this.getPath('content.kind') === 'email';
  }.property('content.kind').cacheable(),
});