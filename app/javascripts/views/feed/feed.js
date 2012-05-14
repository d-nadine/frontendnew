Radium.FeedView = Ember.View.extend({
  classNames: 'feed-item'.w(),
  classNameBindings: ['isActionsVisible:expanded'],
  templateName: 'activity_row',
  // Comments

  feedHeaderView: Ember.View.extend({
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    iconView: Radium.SmallIconView.extend({
      contentBinding: 'parentView.parentView.content',
      classNames: 'pull-left activity-icon'.w()
    }),
    click: function() {
      this.toggleProperty('isActionsVisible');
    }
  }),

  isActionsVisible: false,

  activityActionsView: Ember.ContainerView.extend({
    childViews: [],
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    actionsVisibilityDidChange: function() {
      if (this.get('isActionsVisible')) {
        var activity = this.get('content'),
            commentsView = Radium.InlineCommentsView.create({
              controller: Radium.inlineCommentsController.create({
                activity: activity,
                contentBinding: 'activity.comments'
              }),
              contentBinding: 'controller.content'
            });
        this.get('childViews').pushObject(commentsView);
      } else {
        this.get('childViews').popObject();
        this.setPath('parentView.isEditMode', false);
      }
    }.observes('isActionsVisible')
  }),

  // Inline actions

  addTodo: function(event) {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      target: event.view.get('content'),
      type: 'contacts'
    });

    return false;
  },

  addCallTask: function(event) {
    var id = this.getPath('content.reference.contact.id'),
        kind = this.getPath('content.kind'),
        userId = this.getPath('content.reference.' + kind + '.user'),
        todo = Radium.store.createRecord(Radium.Todo, {
          kind: "call",
          user_id: userId,
          created_at: Ember.DateTime.create().toISO8601(),
          finishBy: Radium.Utils.finishByDate().toISO8601()
        });
        debugger;
    Radium.Todo.reopenClass({
      url: 'contacts/%@/todos'.fmt(id),
      root: 'todo'
    });

    Radium.store.commit();
    return false;
  },

  // Inline form editing
  isEditMode: false,
  isEditVisibleBinding: Ember.Binding.and(
    'isEditMode',
    'isActionsVisible'
  ),
  toggleEditMode: function(event) {
    this.toggleProperty('isEditMode');
    return false;
  }
});