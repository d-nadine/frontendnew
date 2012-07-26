Radium.InlineTodoForm = Ember.Mixin.create({
  showTodoForm: function(event) {
    var childViews = this.get('childViews'),
        feedDetailsContainer = this.get('feedDetailsContainer'),
        currentView = feedDetailsContainer.get('currentView'),
        todoForm = this.get('todoForm'),
        content = this.get('content'),
        tag = content.get('tag'),
        kind = content.get('kind'),
        selection = (tag) ? content.get(kind) : content;

    todoForm.set('selection', selection);

    if (Ember.isEqual(currentView, todoForm)) {
      feedDetailsContainer.set('currentView', null);
    } else {
      feedDetailsContainer.set('currentView', todoForm);
    }

    return false;
  },

  init: function() {
    this._super();
    // Add Todo todoForm
    this.set('todoForm', Radium.TodoForm.create());
  }
});