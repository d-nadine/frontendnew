Radium.todosController = Ember.ArrayProxy.create({
  content: Radium.store.findAll(Radium.Todo),

  overdueTodos: function() {
    return this.filterProperty('isOverdue', true);
  }.property('@each.isOverdue').cacheable(),

  sortedOverdueTodos: function() {
    return this.get('overdueTodos').slice(0).sort(function(a, b) {
      var date1 = a.get('createdAt'),
          date2 = b.get('createdAt');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('overdueTodos.@each').cacheable(),

  // Open Todos
  dueToday: function() {
    return this.filter(function(todo) {
      return todo.get('isToday') && !todo.get('finished');
    });
  }.property('@each.isToday', '@each.finished').cacheable(),

  sortedDueToday: function() {
    return this.get('dueToday').slice(0).sort(function(a, b) {
      var date1 = a.get('createdAt'),
          date2 = b.get('createdAt');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('dueToday.@each').cacheable(),

  isTodayEmpty: Ember.Binding.or(
  'sortedOngoing.length',
  'overdueTodos.length'
  ),
})