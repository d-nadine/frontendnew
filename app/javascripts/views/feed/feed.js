Radium.FeedView = Ember.View.extend({
  classNames: 'feed-item'.w(),
  classNameBindings: [
    'isActionsVisible:expanded',
    'content.isSaving'
  ],
  templateName: 'activity_row',

  didInsertElement: function() {
    if (this.getPath('content.hasAnimation')) {
      this.scrollToChangedFeedItem(this.getPath('content.finished'));
    }
  },

  stateDidChange: function() {
    if (this.get('state') !== 'inDOM') {
      return false;
    }

    if (this.getPath('content.finished')) {
      this.setPath('content.hasAnimation', true);
    } else {
      this.setPath('content.hasAnimation', false);
    }

  }.observes('content.finished'),

  scrollToChangedFeedItem: function(isFinished) {
    var self = this,
        $row = this.$('.feed-header'),
        offset = $row.offset().top - 200,
        bgColor = (isFinished) ? '#D6E9C6' : '#FBB450';

    $('html, body').animate({
        scrollTop: offset
      }, 250, function() {
        $row.animate({
            backgroundColor: bgColor
          }, 250, function() {
            $row.animate({
              backgroundColor: '#fff'
            }, 1500, function() {
              $(this).attr('style', null);
            });
        });
      });

    self.setPath('content.hasAnimation', false);
  },
  // Comments

  feedHeaderView: Ember.View.extend({
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    expandToggleIconView: Ember.View.extend({
      tagName: 'i',
      classNames: 'feed-expand-icon icon-plus'.w(),
      classNameBindings: ['parentView.isActionsVisible:icon-minus']
    }),
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
    var $sender = $(event.target),
        contact = this.getPath('content.reference.contact'),
        user = this.getPath('content.user');

    if (Ember.empty(contact)) {
      Radium.get('formManager').send('showForm', {
        form: 'Todo',
        position: $sender.offset()
      });
    } else {
      Radium.get('formManager').send('showForm', {
        form: 'Todo',
        target: contact,
        type: 'contacts',
        position: $sender.offset()
      });
    }

    return false;
  },

  addCallTask: function(event) {
    var contact = this.getPath('content.reference.contact'),
        kind = this.getPath('content.kind'),
        user = this.getPath('content.' + kind + '.user'),
        userId = this.getPath('content.reference.' + kind + '.user'),
        todo = Radium.store.createRecord(Radium.Todo, {
          kind: "call",
          isCall: true,
          user_id: userId,
          user: user,
          reference: contact,
          created_at: Ember.DateTime.create().toISO8601(),
          finishBy: Radium.Utils.finishByDate(),
          // Have to fake the response from the server, where the timezone is 0, so the filters update instantly.
          finish_by: Radium.Utils.finishByDate().toTimezone().toISO8601(),
          hasNotificationAnim: true
        });
        
    Radium.Todo.reopenClass({
      url: 'contacts/%@/todos'.fmt(contact.id),
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
