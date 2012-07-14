Radium.InlineTodoForm = Ember.Mixin.create({
  showTodoForm: function(event) {
    var childViews = this.get('childViews'),
        todoForm = this.get('todoForm');
    
    if (childViews.indexOf(todoForm) === -1) {
      childViews.pushObject(todoForm);
    } else {
      childViews.removeObject(todoForm);
    }
    
    return false;
  },

  init: function() {
    this._super();
    // Add Todo todoForm
    this.set('todoForm', Radium.TodoForm.create({
      selection: this.get('content')
    }));
  }
});