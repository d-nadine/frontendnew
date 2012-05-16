Radium.FeedView = Ember.View.extend({
  classNames: 'feed-item'.w(),
  classNameBindings: [
    'isActionsVisible:expanded',
    'content.isSaving'
  ],
  templateName: 'activity_row',

  didInsertElement: function() {
    if (this.getPath('content.hasNotificationAnim')) {

      var $newRow = this.$(),
          offset = $newRow.offset().top - 90;
    
      $('html, body').animate({
        scrollTop: offset
      }, 250, function() {
        $newRow.animate({
          backgroundColor: '#FBB450'
        }, 250, function() {
          $newRow.animate({
            backgroundColor: '#fff'
          }, 1500);
        });
      });
    }
  },

  // Comments

  feedHeaderView: Ember.View.extend({
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    iconView: Radium.SmallIconView.extend({
      contentBinding: Ember.Binding.or(
        'parentView.parentView.content',
        'parentView.content'
      ),
      classNames: 'pull-left activity-icon'.w()
    }),
    click: function() {
      this.toggleProperty('isActionsVisible');
    }
  }),

  isActionsVisible: false,

  activityActionsView: Ember.ContainerView.extend({
    childViews: [],
    classNames: ['row'],
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    actionsVisibilityDidChange: function() {
      if (this.get('isActionsVisible')) {
        // Comments are either available from an embedded activity or from the
        // the activity itself if the view is historical.
        var activity = this.getPath('content.activity') || this.get('content'),
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
    var contact = this.getPath('content.reference.contact'),
        user = this.getPath('content.user');

    if (Ember.empty(contact)) {
      Radium.FormManager.send('showForm', {
        form: 'Todo'
      });
    } else {
      Radium.FormManager.send('showForm', {
        form: 'Todo',
        target: contact,
        type: 'contacts'
      });
    }

    return false;
  },

  addCallTask: function(event) {
    var id = this.getPath('content.reference.contact.id'),
        kind = this.getPath('content.kind'),
        user = this.getPath('content.' + kind + '.user'),
        userId = this.getPath('content.reference.' + kind + '.user'),
        todo = Radium.store.createRecord(Radium.Todo, {
          kind: "call",
          user_id: userId,
          user: user,
          created_at: Ember.DateTime.create().toISO8601(),
          finishBy: Radium.Utils.finishByDate().toISO8601()
        });
        
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