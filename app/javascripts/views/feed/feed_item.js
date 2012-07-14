/**
  Every feed item, either a historical activity or a scheduled resource 
  like a todo or deal use this as the start point.

  Initialization sets up the childViews for any forms and comments.
  Override this further for individual needs of the historical/scheduled 
  subclassed views
*/
Radium.FeedItemView = Ember.ContainerView.extend(
  Radium.InlineForm,
  Radium.InlineTodoForm,
  {
  classNames: 'row feed-item-container'.w(),
  classNameBindings: ['isActionsVisible:expanded', 'hasDiscussions'],
  isActionsVisible: false,

  commentsVisibilityDidChange: function() {
    var self = this,
        childViews = this.get('childViews'),
        editView = this.get('editView'),
        infoView = this.get('infoView'),
        commentsView = this.get('commentsView');

    if (this.get('isActionsVisible')) {
      childViews.pushObjects([infoView, commentsView]);
    } else if (childViews.get('length')) {
      childViews.removeObject(editView);
      $.when(commentsView.slideUp())
        .then(function() {
          childViews.removeObjects([commentsView, infoView]);
          self.setPath('parentView.isEditMode', false);
        });
    }
  }.observes('isActionsVisible'),

  edit: function(event) {
    var childViews = this.get('childViews'),
        editView = this.get('editView');

    if (childViews.indexOf(editView) === -1) {
      childViews.pushObject(editView);
    } else {
      childViews.removeObject(editView);
    }
    return false;
  },

  init: function() {
    this._super();

    // Assign the content in the subclassed views
    this.set('commentsController', Radium.InlineCommentsController.create({
      activity: this.get('content')
    }));

    // Add the comments view.
    this.set('commentsView', Radium.InlineCommentsView.create({
      controller: this.get('commentsController'),
      contentBinding: 'controller.content'
    }));
  }
});