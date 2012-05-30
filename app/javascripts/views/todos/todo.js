Radium.TodoView = Ember.View.extend({
  tagName: 'span',
  templateName: 'todo',
  classNames: ['todo'],
  classNameBindings: [
    'content.isOverdue:overdue',
    'content.finished:finished'
  ],
  checkboxView: Ember.Checkbox.extend({
    updatedAtBinding: 'parentView.content.updatedAt',
    finishedBinding: 'parentView.content.finished',
    disabledBinding: 'parentView.content.isSaving',
    checkedBinding: 'parentView.content.finished',
    click: function(event) {
      event.stopPropagation();
    },

    change: function() {
      this.set('updatedAt', Ember.DateTime.create());
      this._super();
    },

    todoValueDidChange: function() {
      Ember.run.next(function() {
        Radium.store.commit();
      });
    }.observes('checked')
  })
});