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
    didInsertElement: function() {
      console.log(this.get('status'));
    },
    tagName: 'span',
    classNames: ['label'],
    statusBinding: 'parentView.content.contact.status',
    classNameBindings: [
      'isLead:label-info',
      'isProspect:label-warning',
      'isOpportunity:label-inverse',
      'isCustomer:label-success',
      'isDeadEnd:label-important'
    ],
    // Status type bindings
    isLead: function() {
      return (this.get('status') === 'lead') ? true : false;
    }.property('status').cacheable(),
    isProspect: function() {
      return (this.get('status') === 'prospect') ? true : false;
    }.property('status').cacheable(), 
    isOpportunity: function() {
      return (this.get('status') === 'opportunity') ? true : false;
    }.property('status').cacheable(),
    isCustomer: function() {
      return (this.get('status') === 'customer') ? true : false;
    }.property('status').cacheable(),
    isDeadEnd: function() {
      return (this.get('status') === 'dead_end') ? true : false;
    }.property('status').cacheable(),

    template: Ember.Handlebars.compile('{{status}}')
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