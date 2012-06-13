Radium.TodoEditView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  templateName: 'todo_edit',
  isEditModeBinding: 'parentView.isEditMode',
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
          todo = this.getPath('parentView.todo');
          
      if (user.get('id') !== todo.getPath('user.id')) {
        todo.setProperties({
          user: user,
          user_id: user.get('id')
        });
        this.setPath('parentView.isEditMode', false);
        Radium.store.commit();
        // user.get('todos').pushObject(todo);
        // oldUser.get('todos').removeObject(todo);
      }
    }.observes('selection')
  }),
  editDueDateField: Radium.DatePickerField.extend({
    classNames: ['span2'],
    valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        return value.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var newFinishBy = Ember.DateTime.parse(value, "%Y-%m-%d"),
            // Adjust to 5PM due time.
            newFinishByTime = newFinishBy.adjust({hour: 17, minute: 0, second: 0});
        return newFinishByTime;
      }
    }).from('parentView.todo.finishBy'),

    valueDidChange: function() {
      Ember.run.next(function() {
        Radium.store.commit();
      });
    }.observes('value')
  })
})