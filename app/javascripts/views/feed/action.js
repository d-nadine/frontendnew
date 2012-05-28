Radium.FeedActionView = Ember.ContainerView.extend({
  childViews: ['todoView'],

  todoView: Radium.TodoView.extend({
    todoBinding: 'content'
  })
});