Radium.HistoricalFeedView = Radium.FeedItemView.extend({
  classNameBindings: ['content.kind'],
  init: function() {
    this._super();

    var content = this.get('content'),
        kind = this.getPath('collectionView.parentView.content.kind'),
        tag = this.getPath('collectionView.parentView.content.tag'),
        // Load the reference in through the store instead of accessing the nested object
        referenceId = content.getPath('reference.' + kind),
        modelString = Radium.Utils.stringToModel(kind);

    // Set the
    this.setProperties({
      reference: Radium.store.find(Radium[modelString], referenceId),
      tag: tag,
      kind: kind
    });
  },
  contentHasLoaded: function() {
    if (!this.getPath('reference.isLoaded')) {
      return false;
    }

    var content = this.get('content'),
        reference = this.get('reference'),
        kind = this.get('kind'),
        tag = this.get('tag');

    content.set(kind, reference);

    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create({
      content: content,
      init: function() {
        this._super();
        var templateName = [kind, tag].join('_');
        this.set('templateName', templateName);
      }
    }));

    this.set('infoView', Ember.View.create({
      content: reference,
      isVisibleBinding: 'parentView.isActionsVisible',
      layoutName: 'details_layout',
      templateName: kind + '_details'
    }));

    //TODO: Joshua there is not NoteFormView?
    // this.set('noteView', Radium.NoteFormView.create({
    //     content: resource
    // }));

    // Assign the comments
    this.setPath('commentsController.content', this.getPath('content.comments'));
  }.observes('reference.isLoaded')
});
