Radium.HistoricalFeedView = Radium.FeedItemView.extend({
  init: function() {
    this._super();
    var content = this.get('content'),
        kind = content.get('kind'),
        // Load the reference in through the store instead of accessing the nested object
        referenceId = content.getPath('reference.' + kind + '.id');

    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create({
      content: content,
      resource: Radium.store.find(Radium[Radium.Utils.stringToModel(kind)], referenceId),
      userBinding: 'resource.user',
      init: function() {
        this._super();
        var kind = this.getPath('content.kind'),
            tag = this.getPath('content.tag'),
            templateName = [kind, tag].join('_');
        this.set('templateName', templateName);
      }
    }));

    this.set('infoView', Ember.View.create({
      isVisibleBinding: 'parentView.isActionsVisible',
      content: this.get('content'),
      layoutName: 'details_layout',
      templateName: kind + '_details'
    }));

    // Assign the comments
    this.setPath('commentsController.content', this.getPath('content.comments'));
  }
});