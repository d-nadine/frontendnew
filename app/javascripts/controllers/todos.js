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
  },
  bootStrapLoaded: function(){
    var feed = Radium.getPath('appController.overdue_feed');

    if(!feed.length || feed.length === 0){
      this.set('content', []);
      return;
    }

    //TODO: Where can we put this for global access?
    var feedTypes = {};
    feedTypes['todo'] = Radium.Todo;
    feedTypes['deal'] = Radium.Deal;
    feedTypes['call_list'] = Radium.CallList;
    feedTypes['contact'] = Radium.Contact;
    feedTypes['email'] = Radium.Email;
    feedTypes['invitation'] = Radium.Invitation;
    feedTypes['meeting'] = Radium.Meeting;
    feedTypes['phone_call'] = Radium.PhoneCall;

    var self = this;

    feed.forEach(function(item){
      var kind = feedTypes[item.kind];

      var reference = item.reference[item.kind];

      Radium.store.load(kind, reference);
      var overdue = Radium.store.find(kind, reference.id);
      
      self.get('content').pushObject(overdue);
    });

    // if(Radium.getPath('appController.overdue_feed.length') !== this.getPath('content.length')){
    //   return;
    // }

    // var createView = function(activity){
    //    return Radium.FeedView.create({
    //     content: activity
    //   });
    // };

    // if(this.getPath('sortedOverdueTodos.length') > 0){
    //   this.batchloadViews(createView, 'sortedOverdueTodos');
    // }

  }.observes('Radium.appController.overdue_feed')
})
