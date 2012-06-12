Radium.FeedGroup = Ember.Object.extend({
  date: null,

  // Open Todos
  ongoingTodos: function() {
    var date = this.get('date');
    return Radium.Todo.filter(function(data) {
      var finishByDate = Ember.DateTime.parse(data.get('finish_by'))
                          .toTimezone(Radium.appController.get('timezone'));
      return Ember.DateTime.compareDate(finishByDate, date) === 0;
    });
  }.property().cacheable(),

  sortedOngoingTodos: function() {
    return this.get('ongoingTodos').slice(0).sort(function(a, b) {
      var date1 = a.get('finishBy'),
          date2 = b.get('finishBy');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('ongoingTodos.@each').cacheable()
});