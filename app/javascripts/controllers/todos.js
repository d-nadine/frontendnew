Radium.TodosController = Ember.ArrayController.extend(Radium.BatchViewLoader, Radium.BinarySearch, {
  content: Ember.A(),
  init: function(){
    this.set('sortedOverdueTodos', Ember.A());
    this.set('sortedDueToday', Ember.A());
    this.set('finishedOverdueTodos', Ember.A());
    this.set('view', Ember.ContainerView.create({}));
    this._super();
  },
  arrayContentDidChange: function(startIdx, removeAmt, addAmt) {
    if(addAmt === 0)
      return;

    var overdueItem = this.objectAt(startIdx);

    if(overdueItem.get('isOverdue')){
      this.get('sortedOverdueTodos').insertAt(this.binarySearch(overdueItem.get('createdAt'), 0, this.getPath('sortedOverdueTodos.length'), 'sortedOverdueTodos', 'createdAt'), overdueItem);
    }

    if(overdueItem.get('isOverdue') && overdueItem.get('isDueToday') && !overdueItem.get('finished')){
      this.get('sortedDueToday').insertAt(this.binarySearch(overdueItem.get('createdAt'), 0, this.getPath('sortedDueToday.length'), 'sortedDueToday', 'createdAt'), overdueItem);
    }

    var updatedAt = overdueItem.get('updatedAt'),
        today = Radium.appController.get('today');

    var isFinishedToday =  overdueItem.get('finished') && Ember.DateTime.compareDate(updatedAt, today) === 0;

    if(overdueItem.get('finished') && isFinishedToday){
      this.get('finishedOverdueTodos').insertAt(this.binarySearch(overdueItem.get('createdAt'), 0, this.getPath('finishedOverdueTodos.length'), 'finishedOverdueTodos', 'createdAt'), overdueItem);
    }

    this._super(startIdx, removeAmt, addAmt);
  }
})
