Radium.FeedView = Ember.View.extend({
  classNames: 'feed-item'.w(),
  classNameBindings: ['isActionsVisible:expanded'],
  templateName: 'activity_row',
  // template: Ember.Handlebars.compile('{{view Radium.TodoView todoBinding="content.todo"}}'),
  // Comments
  iconView: Radium.SmallIconView.extend({
    classNames: 'pull-left activity-icon'.w()
  }),

  isActionsVisible: false,

  click: function() {
    this.toggleProperty('isActionsVisible');
  },

  // Comments
  commentsView: null,

  isCommentsVisible: false,

  commentsView: null,
  
  toggleComments: function() {
    console.log('toggle');
    if (this.get('isActionsVisible')) {
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

    } else {
      if (this.get('commentsView')) {
        this.get('commentsView').remove();
        this.set('commentsView', null);
      }      
    }
  }.observes('isActionsVisible'),
});