Radium.TodoView = Radium.FeedView.extend({
  tagName: 'span',
  templateName: 'todo',
  classNames: ['todo'],
  classNameBindings: [
    'todo.isOverdue:overdue', 
    'todo.finished:finished'
  ],
  checkboxView: Radium.Checkbox.extend({
    valueBinding: 'parentView.todo.finished',
    click: function(event) {
      event.stopPropagation();
    },
    todoDidChange: function() {
      Radium.store.commit();
    }.observes('value')
  })
});