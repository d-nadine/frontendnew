Radium.HistoricalFeedView = Radium.FeedItemView.extend({
  init: function() {
    this._super();
    var content = this.get('content');
    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create({
      content: content,
      init: function() {
        this._super();
        var kind = this.getPath('content.kind'),
            tag = this.getPath('content.tag'),
            templateName = [kind, tag].join('_');
            console.log(templateName);
        this.set('templateName', templateName);
      }
    }));
    // Add a commentsView
   var commentsView = Radium.InlineCommentsView.create({
        controller: Radium.inlineCommentsController.create({
          activity: content,
          contentBinding: 'activity.comments'
        }),
        contentBinding: 'controller.content'
      });
    this.set('commentsView', commentsView);

    // Add Todo Form
    this.set('todoForm', Radium.TodoForm.create());
  }
});