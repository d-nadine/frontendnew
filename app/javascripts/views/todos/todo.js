Radium.TodoView = Ember.View.extend({
  tagName: 'span',
  templateName: 'todo',
  classNames: ['todo'],
  classNameBindings: [
    'content.isOverdue:overdue',
    'content.finished:finished'
  ],
  checkboxView: Ember.Checkbox.extend({
    checkedBinding: 'parentView.content.finished',
    disabledBinding: 'parentView.content.isSaving',
    click: function(event) {
      event.stopPropagation();
    },
    todoDidChange: function() {
      var self = this;
      Ember.run.once(function() {
        self.set('updatedAt', Ember.DateTime.create());
      });

      Ember.run.next(function() {
        Radium.store.commit();
      });
    }.observes('checked')
  })
});