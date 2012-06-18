/**
  Every feed item, either a historical activity or a scheduled resource 
  like a todo or deal use this as the start point.

  Initialization sets up the childViews for any forms and comments.
  Override this further for individual needs of the historical/scheduled 
  subclassed views
*/
Radium.FeedItemView = Ember.ContainerView.extend({
  classNames: 'row feed-item-container'.w(),
  classNameBindings: ['isActionsVisible:expanded'],
  isActionsVisible: false,
  commentsVisibilityDidChange: function() {
    var self = this,
        childViews = this.get('childViews'),
        commentsView = this.get('commentsView');
    if (this.get('isActionsVisible')) {
      childViews.pushObject(commentsView);
    } else if (childViews.get('length')) {
      $.when(commentsView.slideUp())
        .then(function() {
          childViews.removeObject(commentsView);
          self.setPath('parentView.isEditMode', false);
        });
    }
  }.observes('isActionsVisible'),

  showTodoForm: function(event) {
    this.get('childViews').pushObject(this.get('todoForm'));
    return false;
  },

  close: function(event) {
    this.get('childViews').removeObject(this.get('todoForm'));
    return false;
  },

  init: function() {
    this._super();
    // Add Todo todoForm
    this.set('todoForm', Radium.TodoForm.create({
      selection: this.get('content'),
      close: function(event) {
        var self = this,
            parentView = this.get('parentView');
        this.$().slideUp('fast', function() {
          parentView.get('childViews').removeObject(self);
        });
        return false;
      },
      didInsertElement: function() {
        this.addObserver('parentView.isActionsVisible', function() {
          this.close();
        });
      },
      willDestroy: function() {
        this.removeObserver('parentView.isActionsVisible');
      }
    }));

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