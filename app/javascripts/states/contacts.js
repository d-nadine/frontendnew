Radium.ContactsPage = Ember.State.extend({
  index: Ember.State.extend({
    enter: function(manager) {
      this._super(manager);

      rootView = manager.get('rootView');

      rootView.get('childViews').removeObject(rootView.get('loading'));

      Radium.get('activityFeedController').set('canScroll', false);

      if(!manager.get('contactsSideBarView')){
        manager.set("contactsSideBarView",  Radium.ContactsSideBar.create({
        }));
      }

      Radium.get('appController').set('sideBarView', manager.get('contactsSideBarView'));

      if(!manager.get('contactsFeedView')){
        manager.set('contactsFeedView', Radium.ContactsPageView.create({
          controller: Radium.get('appController.contactsController')
        }))
      }

      Radium.get('appController').set('feedView', manager.get('contactsFeedView'));
    }
  }),
  
  show: Ember.State.extend({
    enter: function(manager) {
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
