Radium.TodoView = Radium.FeedView.extend({
  tagName: 'span',
  templateName: 'todo',
  classNames: ['todo'],
  classNameBindings: [
    'todo.isOverdue:overdue',
    'todo.finished:finished'
  ],
  checkboxView: Radium.Checkbox.extend({
    checkedBinding: 'parentView.todo.finished',
    disabledBinding: 'parentView.todo.isSaving',
    click: function(event) {
      event.stopPropagation();
    },
    todoDidChange: function() {
      Ember.run.next(function() {
        Radium.store.commit();
      });
    }.observes('checked')
  })
});