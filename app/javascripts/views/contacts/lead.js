Radium.LeadView = Radium.FeedView.extend({
  templateName: 'lead',
  root: 'contacts',
  classNames: ['feed-item', 'contact-lead'],
  isReassigning: null,
  reassign: function(event) {
    this.toggleProperty('isReassigning');
    return false;
  },
  userSelect: Ember.Select.extend({
    didInsertElement: function() {
      var self = this;
      this.$().focus();
      $('html').on('click.namespace', function() {
        self.setPath('parentView.isReassigning', false);
      });

      var assignedTo = this.getPath('parentView.content.user');
      this.set('selection', assignedTo);

      this._super();
    },
    willDestroyElement: function() {
      $('html').off('click.namespace');
    },
    keyUp: function(event) {
      if (event.keyCode === 27) {
        this.setPath('parentView.isReassigning', false);
      }
    },
    contentBinding: 'Radium.usersController.content',
    optionLabelPath: 'content.name',
    optionValuePath: 'content.id',
    reassignLead: function(user, lead) {
      if (user.get('id') !== lead.getPath('user.id')) {
        lead.set('user', user.get('id'));
        user.get('contacts').pushObject(lead);
        Radium.store.commit();
        this.setPath('parentView.isReassigning', false);
      }
    },
    assignmentDidChange: function() {
      var user = this.get('selection'), 
          oldUser = this.getPath('parentView.content.user'),
          lead = this.getPath('parentView.content');
          
      if (user.get('id') !== lead.getPath('user.id')) {
        lead.setProperties({
          user: user,
          user_id: user.get('id')
        });
        Radium.store.commit();
        // user.get('contacts').pushObject(lead);
        // oldUser.get('contacts').removeObject(lead);
        this.setPath('parentView.isReassigning', false);
      }
    }.observes('selection')
  }),

  addTodo: function(event) {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      target: event.view.get('content'),
      type: 'contacts'
    })

    return false;
  },

  addCallTask: function(event) {

    var id = this.getPath('content.id'),
        user = this.getPath('content.user'),
        todo = Radium.store.createRecord(Radium.Todo, {
          kind: "call",
          user: user,
          created_at: Ember.DateTime.create().toISO8601(),
          finishBy: Ember.DateTime.create({
            hour: 17
          }).toISO8601()
        });

    Radium.Todo.reopenClass({
      url: 'contacts/%@/todos'.fmt(id),
      root: 'todo'
    });

    Radium.store.commit();
    return false;
  }
});