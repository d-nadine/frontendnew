Radium.TodoEditView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  templateName: 'todo_edit',
  contentBinding: 'parentView.content',
  isEditModeBinding: 'parentView.isEditMode',
  userSelect: Ember.Select.extend({
    init: function() {
      this._super();
      var assignedTo = this.getPath('parentView.content.user');
      this.set('selection', assignedTo);
    },
    didInsertElement: function() {
      this.$().focus();
    },
    contentBinding: 'Radium.usersController.content',
    optionLabelPath: 'content.name',
    optionValuePath: 'content.id',
    assignmentDidChange: function() {
      var user = this.get('selection'), 
          todo = this.getPath('parentView.content'),
          oldUser = todo.get('user');
          
      if (user.get('id') !== todo.getPath('user.id')) {
        todo.setProperties({
          user: user,
          user_id: user.get('id')
        });

        // user.get('todos').pushObject(todo);
        // oldUser.get('todos').removeObject(todo);
        Ember.run.next(function() {
          Radium.store.commit();
        });
      }
    }.observes('selection')
  }),
  editDueDateField: Radium.DatePickerField.extend({
    elementId: 'finish-by-date',
    name: 'finish-by-date',
    classNames: ['input-small'],
    minDate: function() {
      var now = Ember.DateTime.create();
      return (now.get('hour') >= 17) ? '+1d' : new Date();
    }.property().cacheable(),
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
    }).from('parentView.content.finishBy'),
    change: function() {
      Ember.run.next(function() {
        Radium.store.commit();
      });
      this._super();
    }
  })
})