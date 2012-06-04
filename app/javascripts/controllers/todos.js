Radium.TodosController = Ember.ArrayController.extend({
  //TODO: review
  // content: Radium.store.findAll(Radium.Todo),
  init: function(){
    this.set('content', Radium.store.findAll(Radium.Todo)); 
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
      this.get('sortedOverdueTodos').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('sortedOverdueTodos.length')), todo, 'sortedOverdueTodos', 'createdAt');
    }

    if(todo.get('isOverdue') && todo.get('dueToday') && !todo.get('finished')){
      this.get('sortedDueToday').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('sortedDueToday.length')), todo, 'sortedDueToday', 'createdAt');
    }

    var updatedAt = todo.get('updatedAt'),
        today = Radium.appController.get('today');

    var isFinishedToday =  todo.get('finished') && Ember.DateTime.compareDate(updatedAt, today) === 0;

    if(todo.get('finished') && isFinishedToday){
      this.get('finishedOverdueTodos').insertAt(this.binarySearch(todo.get('createdAt'), 0, this.getPath('finishedOverdueTodos.length')), todo, 'finishedOverdueTodos', 'createdAt');
    }

    this._super(startIdx, removeAmt, addAmt);
  },
  binarySearch: function(value, low, high, arrayName, property) {
    var mid, midValue;

    if (low === high) {
      return low;
    }

    mid = low + Math.floor((high - low) / 2);
    midValue = this.get(arrayName).objectAt(mid).get(property);

    if (value < midValue) {
      return this.binarySearch(value, mid+1, high);
    } else if (value > midValue) {
      return this.binarySearch(value, low, mid);
    }

    return mid;
  }
})
