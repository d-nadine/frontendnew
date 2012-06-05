Radium.TodosController = Ember.ArrayController.extend(Radium.BinarySearch, {
  //TODO: review
  // content: Radium.store.findAll(Radium.Todo),
  init: function(){
    this.set('sortedOverdueTodos', Ember.A());
    this.set('sortedDueToday', Ember.A());
    this.set('finishedOverdueTodos', Ember.A());
    this._super();
  },
  arrayContentDidChange: function(startIdx, removeAmt, addAmt) {
    if(addAmt === 0)
      return;

    var todo = this.objectAt(startIdx);

    if(todo.get('isOverdue')){
      this.get('sortedOverdueTodos').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('sortedOverdueTodos.length'), 'sortedOverdueTodos', 'createdAt'), todo);
    }

    if(todo.get('isOverdue') && todo.get('dueToday') && !todo.get('finished')){
      this.get('sortedDueToday').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('sortedDueToday.length'), 'sortedDueToday', 'createdAt'), todo);
    }

    var updatedAt = todo.get('updatedAt'),
        today = Radium.appController.get('today');

    var isFinishedToday =  todo.get('finished') && Ember.DateTime.compareDate(updatedAt, today) === 0;

    if(todo.get('finished') && isFinishedToday){
      this.get('finishedOverdueTodos').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('finishedOverdueTodos.length'), 'finishedOverdueTodos', 'createdAt'), todo);
    }

    this._super(startIdx, removeAmt, addAmt);
  },
  bootStarpLoaded: function(){
    var feed = Radium.getPath('appController.overdue_feed');
    //TODO: is there a base type for todos deals etc.?
    Radium.store.loadMany(Radium.Todo, feed.map(function(item){
      return item.reference[item.kind];
    }));

    this.set('content', Radium.store.findAll(Radium.Todo, feed.mapProperty('id')));
  }.observes('Radium.appController.overdue_feed')
})
