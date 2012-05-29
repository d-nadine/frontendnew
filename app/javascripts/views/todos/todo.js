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
    click: function(event) {
      this.set('updatedAt', Ember.DateTime.create())
          .toggleProperty('finished');
      Radium.store.commit();
      event.stopPropagation();
    }
  })
});