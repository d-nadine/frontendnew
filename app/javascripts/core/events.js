Radium.Events = Ember.Object.create({
  streamUpdated: function(data){
    console.log(data);
  },
  streamDeleted: function(data){
    console.log('in deleted');
    console.log(data);
  },
  streamCreated: function(push){
    if(push.hasOwnProperty('activity')){
      if(push.activity.tag !== 'scheduled_for'){
        this.insertActivity(push.activity);
      }
    }else if(push.hasOwnProperty('notification')){
      this.insertNotification(push.notification);
    }else{
      this.insertReference(push);
    }
  },
  insertNotification: function(data){
    Radium.store.load(Radium.Notification, data);
    var notification  = Radium.store.find(Radium.Notification, data.id);

    Radium.getPath('notificationsController.content').insertAt(0, notification);
  },
  insertReference: function(push){
    var details = this.getReferenceDetails(push),
      date = Ember.DateTime.parse(details.reference.calendar_time, '%Y-%m-%d');

    Radium.store.load(details.model, details.reference);
    var model = Radium.store.find(details.model, details.reference.id);

    if(Ember.DateTime.isToday(date)){
      Radium.getPath('datebookSectionController.content').insertAt(0, model);
      return;
    }

    var feedContent = Radium.getPath('activityFeedController.forwardContent.realContent');

    var existingDate = this.getExistingDate(date);

    if(!existingDate){
      //The date is not in the DOM so do nothing
      return;
    }

    var nextIndex = (feedContent.indexOf(existingDate) + 1);

    var nextContent = feedContent[nextIndex];
    
    if(Ember.isArray(nextContent)){
      nextContent.insertAt(0, model);
    }else{
      feedContent.insertAt(nextIndex, Ember.A([model]));
    } 
  },
  insertActivity: function(activity){
    Radium.store.load(Radium.Activity, activity);
    
    var model = Radium.store.find(Radium.Activity, activity.id),
        date = Ember.DateTime.parse(activity.timestamp, '%Y-%m-%d'),
        startIndex = 0,
        mainContent = null,
        firstCluster = null;

    if(Ember.DateTime.isToday(date)){
      startIndex = 0;

      mainContent = Radium.getPath('activityFeedController.content');
    }else{
      var existingDate = this.getExistingDate(date);

      if(!existingDate){
        //The date is not in the DOM so do nothing
        return;
      }

      mainContent = Radium.getPath('activityFeedController.forwardContent.realContent');
      
      startIndex = (mainContent.indexOf(existingDate) + 1);
    }

    var mainContentLength = mainContent.get('length');

    for(var i = startIndex;i < mainContentLength; i++){
      var item = mainContent.objectAt(i);

      if(item.get('dateHeader')){
        break;
      }

      if(item.get('activities') && item.get('kind')){
        if(!firstCluster){
          firstCluster = item;
        }

        if((activity.kind === item.get('kind')) && (activity.tag === item.get('tag'))){
          item.get('activities').pushObject(activity.id);
          return;
        }
      }
    }

    var nextIndex = (firstCluster) ? mainContent.indexOf(firstCluster) : startIndex;

    mainContent.insertAt(nextIndex, this.getClusterFromActivity(activity));
  },
  getClusterFromActivity: function(activity){
    return Ember.Object.create({tag:activity.tag, kind: activity.kind, count :1,"meta":null, activities: [activity.id]});
  },
  getExistingDate: function(date){
     var dateString = date.toFormattedString('%Y-%m-%d');

    return Radium.getPath('activityFeedController.dateHash')[dateString];
  },
  getReferenceDetails: function(reference){
    if(reference.hasOwnProperty('meeting')){
      return {reference: reference['meeting'], model: Radium.Meeting};
    }else if(reference.hasOwnProperty('todo')){
      return {reference: reference['todo'], model: Radium.Todo};
    }

    throw new Error('Unkown reference passed to pusher.getReferenceType');
  }
});
