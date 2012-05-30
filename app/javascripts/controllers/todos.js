Radium.todosController = Ember.ArrayController.extend({
  content: Radium.store.findAll(Radium.Todo),

  overdueTodos: function() {
    return this.filterProperty('isOverdue', true);
  }.property('@each.isOverdue'),

  sortedOverdueTodos: function() {
    return this.get('overdueTodos').slice(0).sort(function(a, b) {
      var date1 = a.get('createdAt'),
          date2 = b.get('createdAt');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('overdueTodos.@each'),

  finishedOverdueTodos: function() {
    return this.filter(function(todo) {
      var updatedAt = todo.get('updatedAt'),
          today = Radium.appController.get('today');
      return todo.get('finished') && Ember.DateTime.compareDate(updatedAt, today) === 0;
    });
  }.property('@each.finished'),

  // Open Todos
  dueToday: function() {
    return this.filter(function(todo) {
      return todo.get('isDueToday') && !todo.get('finished');
    });
  }.property('@each.isDueToday', '@each.finished'),

  sortedDueToday: function() {
    return this.get('dueToday').slice(0).sort(function(a, b) {
      var date1 = a.get('createdAt'),
          date2 = b.get('createdAt');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('dueToday.@each')
})
