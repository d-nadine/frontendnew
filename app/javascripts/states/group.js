Radium.Group = Ember.State.extend({
  show: Ember.State.extend({
    enter: function(manager) {
      this._super();
  
      var self = this,
          groupId = Radium.appController.get('params');

      rootView = manager.get('rootView');

      rootView.get('childViews').removeObject(rootView.get('loading'));

      Radium.get('activityFeedController').set('canScroll', false);

      Radium.set('groupFeedController', Radium.GroupFeedController.create());

      Radium.get('groupFeedController').set('feedUrl', function(date){
        var resource = 'groups';
        return Radium.get('appController').getFeedUrl(resource, groupId, date);       
      });
    
      if(!manager.get('groupSideBarView')){
          manager.set("groupSideBarView",  Radium.GroupSideBar.create({
        }));
      }

      var today = Ember.DateTime.create({}).toFormattedString('%Y-%m-%d');

      Radium.get('groupFeedController').set('previous_activity_date', today);
      Radium.get('groupFeedController').set('next_activity_date', today);

      Radium.get('appController').set('sideBarView', manager.get('groupSideBarView'));

      Radium.get('appController').set('feedView', Ember.View.create(Radium.InfiniteScroller, {
          templateName: 'group_feed',
          contentBinding: 'Radium.groupFeedController.content',
          controllerBinding: 'Radium.groupFeedController',
          didInsertElement: function(){
            $('html,body').scrollTop(5);
            Radium.get('groupFeedController').set('canScroll', true);
          }
        }));
    }
  })
});
