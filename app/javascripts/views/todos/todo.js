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
      /*
        To keep the UI separating, we need to toggle the finished 
        property on click instead of through bindings so updatedAt 
        can be set at the same time.
      */
      this.set('updatedAt', Ember.DateTime.create())
          .toggleProperty('finished');
      Radium.store.commit();
      event.stopPropagation();
    }
  })
});