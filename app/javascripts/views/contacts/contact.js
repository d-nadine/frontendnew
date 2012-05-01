Radium.ContactPageView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'contact',
  contentBinding: 'Radium.selectedContactController.content',
  addContactTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      id: this.getPath('content.id'),
      type: 'contacts'
    });
    return false;
  },

  addContactToGroup: function() {
    Radium.FormManager.send('showForm', {
      form: 'AddToGroup'
    });
    return false;
  },

  addContactToCompany: function() {
    Radium.FormManager.send('showForm', {
      form: 'AddToCompany'
    });
    return false;
  },

  // Endless scrolling properties
  feedBinding: 'content.feed',
  pageBinding: 'content.feed.page',
  totalPagesBinding: 'content.feed.totalPages',
  targetIdBinding: 'content.id',
  feedUrl: '/api/contacts/%@/feed'
});