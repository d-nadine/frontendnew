Radium.States.Group = Ember.State.extend({
  show: Ember.State.extend({
    enter: function(manager) {
      ///groups/497:A,489,490,495,491,492,496,494,498,493
      this._super();
  
      var self = this,
          groupId = Radium.appController.get('params');

      rootView = manager.get('rootView');

      rootView.get('childViews').removeObject(rootView.get('loading'));

      Radium.get('activityFeedController').set('canScroll', false);

      Radium.set('groupFeedController', Radium.GroupFeedController.create());

      Radium.get('groupFeedController').set('feedUrl', function(date){
        return Radium.get('appController').getFeedUrl('groups', groupId, date);
      });

      Radium.get('groupFeedController').set('group', Radium.store.find(Radium.Group, groupId));
    
      if(!manager.get('groupSideBarView')){
          manager.set("groupSideBarView",  Radium.GroupSideBar.create({
        }));
      }

      Radium.get('appController').set('sideBarView', manager.get('groupSideBarView'));

      Radium.get('appController').set('feedView', Ember.View.create(Radium.InfiniteScroller, {
          templateName: 'general_feed',
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
