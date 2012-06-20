Radium.Events = Ember.Object.create({
  streamUpdated: function(data){
    console.log(data);
  },
  steamDeleted: function(data){
    console.log('in deleted');
    console.log(data);
  },
  streamCreated: function(push){
    if(push.data.hasOwnProperty('activity')){
      this.insertActivity(push.data.activity);
    }else{
      this.insertReference(push.data);
    }
  },
  insertReference: function(push){
    var details = this.getReferenceDetails(push),
      date = Ember.DateTime.parse(details.reference.updated_at, '%Y-%m-%d');

    Radium.store.load(details.model, details.reference);
    var model = Radium.store.find(Radium.Meeting, details.reference.id);


    if(Ember.DateTime.isToday(date)){
      Radium.getPath('scheduledActivitiesController.content').insertAt(0, model);
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
        date = Ember.DateTime.parse(activity.updated_at, '%Y-%m-%d'),
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
          console.log('add to cluster');
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
  getReferenceDetails: function(data){
    if(data.hasOwnProperty('meeting')){
      return {reference: data['meeting'], model: Radium.Meeting};
    }else if(data.hasOwnProprty('todo')){
      return {reference: data['todo'], model: Radium.Todo};
    }

    throw new Error('Unkown reference passed to pusher.getReferenceType');
  }
});
