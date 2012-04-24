Radium.TodoView = Ember.View.extend({
  templateName: 'todo',
  classNames: ['feed-item', 'todo'],
  classNameBindings: [
    'content.isOverdue:overdue', 
    'content.finished:finished'
  ],
  checkboxView: Radium.Checkbox.extend({
    valueBinding: 'parentView.content.finished',
    click: function() {
      Radium.store.commit();
    }
  }),

  // Comments
  commentsView: null,

  isCommentsVisible: false,

  commentsView: null,
  
  toggleComments: function() {
    if (this.get('commentsView')) {
      this.get('commentsView').remove();
    } else {
      var commentsView = Radium.InlineCommentsView.create();
      this.set('commentsView', commentsView);
      commentsView.appendTo(this.$());
    }
    this.toggleProperty('isCommentsVisible');
  }
});