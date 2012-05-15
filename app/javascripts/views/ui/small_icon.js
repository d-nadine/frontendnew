Radium.SmallIconView = Ember.View.extend({
  tagName: 'i',
  classNames: ['pull-left'],
  classNameBindings: [
    'todo:icon-check',
    'contact:icon-user',
    'email:icon-envelope',
    'call:icon-arrow-right'
  ],
  todo: function() {
    return this.get('kind') === 'todo' || this.get('kind') === 'general';
  }.property('kind').cacheable(),
  contact: function() {
    return this.get('kind') === 'contact';
  }.property('kind').cacheable(),
  email: function() {
    return this.get('kind') === 'email';
  }.property('kind').cacheable(),
  call: function() {
    return this.get('kind') === 'call';
  }.property('kind').cacheable()
});