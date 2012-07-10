Radium.ContactsPage = Ember.State.extend({
  index: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      if(!manager.get('contactsSideBarView')){
          manager.set("contactsSideBarView",  Radium.ContactsSideBar.create({
        }));
      }

      Radium.get('appController').set('sideBarView', manager.get('contactsSideBarView'));

      if(!manager.get('contactsFeedView')){
        manager.set('contactsFeedView', Radium.ContactsPageView.create({}))
      }

      Radium.get('contactsController').load();

      Radium.get('appController').set('feedView', manager.get('contactsFeedView'));
    }
  }),
  
  show: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      var contact = Radium.store.find(Radium.Contact, Radium.appController.get('params'));
      
      Radium.set('selectedContactController', Radium.SelectedContactController.create());

      Radium.get('selectedContactController').set('contact', contact);

      Radium.get('appController').set('sideBarView', Radium.ContactSidebar.create({
        content: contact
      }));

      var contactsView = Radium.ContactPageView.create({});
      
      Radium.get('appController').set('feedView', contactsView);
    },
    exit: function(manager) {
      this._super(manager);
      Radium.selectedContactController.set('contact', null);
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
