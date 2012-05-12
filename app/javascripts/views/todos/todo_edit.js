Radium.TodoEditView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  templateName: 'todo_edit',
  userSelect: Ember.Select.extend({
    didInsertElement: function() {
      var self = this;
      this.$().focus();

      var assignedTo = this.getPath('parentView.todo.user');
      this.set('selection', assignedTo);

      this._super();
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
          oldUser = this.getPath('parentView.todo.user'),
          lead = this.getPath('parentView.todo');
          
      if (user.get('id') !== lead.getPath('user.id')) {
        lead.setProperties({
          user: user,
          user_id: user.get('id')
        });
        Radium.store.commit();
        // user.get('contacts').pushObject(lead);
        // oldUser.get('contacts').removeObject(lead);
      }
    }.observes('selection')
  }),
  editDueDateField: Radium.DatePickerField.extend({
    classNames: ['span2'],
    valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        var date = Ember.DateTime.create(new Date(value));
        return date.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var dateValues;
        if (value) {
          dateValues = value.split('-');
          return new Date(Date.UTC(
            dateValues[0], 
            dateValues[1] - 1, 
            dateValues[2], 
            17));
        } else {
          return new Date().setHours(17);
        }
      }
    }).from('parentView.todo.finishBy'),

    valueDidChange: function() {
      Ember.run(function() {
        Radium.store.commit();
      });
    }.observes('value')
  })
})