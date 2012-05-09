Radium.TodoView = Radium.FeedView.extend({
  templateName: 'todo',
  classNames: ['feed-item', 'todo'],
  root: 'todos',
  classNameBindings: [
    'content.isOverdue:overdue', 
    'content.finished:finished'
  ],
  checkboxView: Radium.Checkbox.extend({
    valueBinding: 'parentView.content.finished',
    click: function() {
      Radium.store.commit();
    }
  })
});