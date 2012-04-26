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

  statusLabelView: Ember.View.extend({
    tagName: 'span',
    classNames: ['label'],
    contactBinding: 'parentView.content.contact',
    classNameBindings: [
      'isLead:label-info',
      'isProspect:label-warning',
      'isOpportunity:label-inverse',
      'isCustomer:label-success',
      'isDeadEnd:label-important'
    ],
    // Status type bindings
    isLead: function() {
      return (this.getPath('contact.status') === 'lead') ? true : false;
    }.property('contact.status').cacheable(),
    isProspect: function() {
      return (this.getPath('contact.status') === 'prospect') ? true : false;
    }.property('contact.status').cacheable(), 
    isOpportunity: function() {
      return (this.getPath('contact.status') === 'opportunity') ? true : false;
    }.property('contact.status').cacheable(),
    isCustomer: function() {
      return (this.getPath('contact.status') === 'customer') ? true : false;
    }.property('contact.status').cacheable(),
    isDeadEnd: function() {
      return (this.getPath('contact.status') === 'dead_end') ? true : false;
    }.property('contact.status').cacheable(),

    template: Ember.Handlebars.compile('{{contact.status}}')
  }),

  // Comments
  commentsView: null,

  isCommentsVisible: false,

  commentsView: null,
  
  toggleComments: function() {
    if (this.get('commentsView')) {
      this.get('commentsView').remove();
      this.set('commentsView', null);
    } else {
      var activity = this.get('content'),
          commentsController = Radium.inlineCommentsController.create({
            activity: activity,
            contentBinding: 'activity.comments'
          }),
          commentsView = Radium.InlineCommentsView.create({
            controller: commentsController,
            contentBinding: 'controller.content'
          });
      this.set('commentsView', commentsView);
      commentsView.appendTo(this.$());
    }
    this.toggleProperty('isCommentsVisible');
  }
});