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
        this.set('templateName', templateName);
      }
    }));

    // Assign the comments
    this.setPath('commentsController.content', this.getPath('content.comments'));
  }
});