Radium.States.Group = Ember.State.extend({
  show: Radium.State.extend({
    enter: function(manager, transition) {
      ///groups/497:A,489,490,495,491,492,496,494,498,493
      this._super(manager, transition);
  
      var self = this,
          groupId = Radium.appController.get('params');

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

      Radium.get('appController').set('feedView', Radium.GroupFeedView.create());
    }
  })
});
