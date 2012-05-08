Radium.LeadView = Radium.FeedView.extend({
  templateName: 'lead',
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
    assignmentDidChange: function() {
      // var assignee = this.get('selection'),
      //     lead = this.getPath('parentView.content');

      // if (assignee.get('id')) {
      //   lead.set('user', assignee.get('id'));
      // }
    }.observes('selection')
  }),

  addTodo: function(event) {
    Radium.FormManager.send('showForm', {
      form: 'Todo',
      target: event.view.get('content'),
      type: 'contacts'
    })

    return false;
  }
});