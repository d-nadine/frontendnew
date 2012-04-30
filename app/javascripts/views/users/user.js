Radium.UserPageView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'user',
  contentBinding: 'Radium.selectedUserController.content',

  // Endless scrolling properties
  feedBinding: 'content.feed',
  pageBinding: 'content.feed.page',
  totalPagesBinding: 'content.feed.totalPages',
  targetIdBinding: 'content.id',
  feedUrl: '/api/users/%@/feed'
});