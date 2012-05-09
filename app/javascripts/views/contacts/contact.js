Radium.ContactPageView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'contact',
  contentBinding: 'Radium.selectedContactController.content',
  addContactTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      type: 'contacts',
      target: this.get('content')
    });
    return false;
  },

  emailContact: function() {
    Radium.FormManager.send('showForm', {
      form: 'Message',
      type: 'contacts',
      target: this.get('content')
    });
    return false;
  },

  addContactToGroup: function() {
    Radium.FormManager.send('showForm', {
      form: 'AddToGroup',
      target: this.get('content')
    });
    return false;
  },

  addContactToCompany: function() {
    Radium.FormManager.send('showForm', {
      form: 'AddToCompany',
      target: this.get('content')
    });
    return false;
  },

  // Endless scrolling properties
  feedBinding: 'content.feed',
  pageBinding: 'content.feed.page',
  totalPagesBinding: 'content.feed.totalPages',
  // targetIdBinding: 'content.id',
  feedUrl: '/api/contacts/%@/feed'
});