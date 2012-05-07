Radium.FeedView = Ember.View.extend({
  layout: Ember.Handlebars.compile('<div class="row">{{yield}}</div>'),
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