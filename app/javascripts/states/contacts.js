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

      debugger;

      Radium.get('contactsController').load();

      Radium.get('appController').set('feedView', manager.get('contactsFeedView'));
    }
  }),
  
  show: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      var self = this,
          contactId = Radium.appController.get('params');

      var contact = Radium.store.find(Radium.Contact, contactId);
      
      Radium.selectedContactController.set('content', contact);
      
      var view = Radium.ContactPageView.create();

      this.set('view', view);

      Radium.selectedContactController.set('view', view);

      this._super(manager);
    },

    exit: function(manager) {
      this._super(manager);
      Radium.selectedContactController.set('content', null);
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
