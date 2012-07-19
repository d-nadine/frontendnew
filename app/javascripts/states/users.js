Radium.UsersPage = Radium.State.extend({
  index: Ember.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      Radium.get('appController').set('sideBarView', Radium.UserSideBar.create({}));
    }
  }),
  
  show: Ember.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      var selectedUser = Radium.selectedUserController,
          user = Radium.store.find(Radium.User, Radium.appController.get('params'));

      Radium.set('selectedUserController', Radium.SelectedUserController.create({}));

      Radium.get('selectedUserController').setProperties({
        user: user
      });

      Radium.get('appController').set('sideBarView', Radium.UserSidebarView.create({
        controller: Radium.get('selectedUserController')
      }));

      var userView = Radium.UserPageView.create({
        controller: Radium.get('selectedUserController')
      });

      Radium.get('appController').set('feedView', userView);
    },
    exit: function(manager) {
      this._super(manager);
      Radium.selectedUserController.set('content', null);
    }
  })
})