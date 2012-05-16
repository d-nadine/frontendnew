Radium.SmallIconView = Ember.View.extend({
  tagName: 'i',
  classNames: ['pull-left'],
  classNameBindings: [
    'todo:icon-check',
    'contact:icon-user',
    'email:icon-envelope',
    'call:icon-arrow-right',
    'assigned:icon-inbox'
  ],
  todo: function() {
    if (this.getPath('content.kind') === 'todo' && this.getPath('content.tag') !== 'assigned') {
      return true;
    } else if (this.getPath('content.kind') === 'general') {
      return true;
    } else {
      return false;
    }
  }.property('content.kind').cacheable(),
  contact: function() {
    return this.getPath('content.kind') === 'contact';
  }.property('content.kind').cacheable(),
  email: function() {
    return this.getPath('content.kind') === 'email';
  }.property('content.kind').cacheable(),
  call: function() {
    return this.getPath('content.kind') === 'call';
  }.property('content.kind').cacheable(),
  assigned: function() {
    return this.getPath('content.kind') === 'todo' && this.getPath('content.tag') === 'assigned';
  }.property('content.kind', 'content.tag').cacheable()
});