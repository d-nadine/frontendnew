/**
  Every feed item, either a historical activity or a scheduled resource
  like a todo or deal use this as the start point.

  Initialization sets up the childViews for any forms and comments.
  Override this further for individual needs of the historical/scheduled
  subclassed views
*/
Radium.FeedItemView = Ember.ContainerView.extend(Radium.InlineTodoForm, {
  classNames: 'row feed-item-container'.w(),
  classNameBindings: ['isActionsVisible:expanded', 'hasDiscussions'],
  isActionsVisible: false,

  commentsVisibilityDidChange: function() {
    var self = this,
        childViews = this.get('childViews'),
        editView = this.get('editView'),
        feedDetailsContainer = this.get('feedDetailsContainer'),
        commentsView = this.get('commentsView');

    if (this.get('isActionsVisible')) {
      childViews.pushObject(feedDetailsContainer);
    } else {
      feedDetailsContainer.slideUp(function() {
        childViews.removeObject(feedDetailsContainer);
        feedDetailsContainer.set('currentView', null);
      });
    }
  }.observes('isActionsVisible'),

  init: function() {
    this._super();

    var kind = this.getPath('content.type') || this.getPath('content.kind'),
        content = (this.getPath('content.type')) ? this.get('content') : this.getPath('parentView.content');

    this.set('controller', Radium.InlineCommentsController.create());

    this.set('feedDetailsContainer', Radium.FeedDetailsContainer.create(Radium.InlineForm, {
      type: kind,
      content: content
    }));
  }
});