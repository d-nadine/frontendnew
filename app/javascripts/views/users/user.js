Radium.UserPageView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'user',
  contentBinding: 'Radium.selectedUserController.content',

  addUserTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      id: this.getPath('content.id'),
      target: this.get('content'),
      type: 'user'
    });
    return false;
  },

  // Endless scrolling properties
  feedBinding: 'content.feed',
  pageBinding: 'content.feed.page',
  totalPagesBinding: 'content.feed.totalPages',
  targetIdBinding: 'content.id',
  feedUrl: '/api/users/%@/feed'
});
