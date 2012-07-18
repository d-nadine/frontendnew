Radium.ContactsPage = Ember.State.extend({
  index: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      Radium.get('appController').set('sideBarView', Radium.ContactsSideBar.create({}));

      Radium.get('contactsController').load();

      Radium.get('appController').set('feedView', Radium.ContactsPageView.create({}));
    }
  }),
  
  show: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      var contact = Radium.store.find(Radium.Contact, Radium.appController.get('params'));

      Radium.set('selectedContactController', Radium.SelectedContactController.create({}));
      
      Radium.get('selectedContactController').setProperties({
        contact: contact,
        user: Radium.appController.getPath('current_user')
      });

      Radium.get('appController').set('sideBarView', Radium.ContactSidebar.create({
        controller: Radium.get('selectedContactController'),
        content: contact
      }));

      var contactsView = Radium.ContactPageView.create({
        controller: Radium.get('selectedContactController')
      });
      
      Radium.get('appController').set('feedView', contactsView);
    },
    exit: function(manager) {
      this._super(manager);
    },
    ready: Ember.State.create()
  }),
  // Events
  allCampaigns: function(manager, context) {
    Radium.contactsController.clearSelected();
    Radium.selectedContactsController.setProperties({
      content: Radium.contactsController.get('content'),
      selectedCampaign: null
    });
    manager.goToState('ready');
  },

  selectCampaign: function(manager, context) {
    $(window).off();
    Radium.contactsController.clearSelected();
    Radium.selectedContactsController.setProperties({
      content: context.get('contacts'),
      selectedCampaign: context
    });
    manager.goToState('ready');
  }
});
