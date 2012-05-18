Radium.SmallIconView = Ember.View.extend({
  tagName: 'i',
  classNames: ['pull-left'],
  classNameBindings: [
    'todo:icon-todo',
    'contact:icon-contact',
    'email:icon-envelope',
    'call:icon-call',
    'assigned:icon-assigned'
  ],
  todo: function() {
    if (this.getPath('content.isCall')) {
      return false;
    }

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
    return (this.getPath('content.isCall')) ? true : false;
  }.property('content.isCall').cacheable(),
  assigned: function() {
    return this.getPath('content.kind') === 'todo' && this.getPath('content.tag') === 'assigned';
  }.property('content.kind', 'content.tag').cacheable()
});