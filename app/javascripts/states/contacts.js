Radium.ContactsPage = Ember.State.extend({
  index: Ember.State.extend({
    enter: function(manager) {
      this._super(manager);

      rootView = manager.get('rootView');

      rootView.get('childViews').removeObject(rootView.get('loading'));

      //TODO: split out ContactsPageView
      Radium.get('appController').set('sideBarView', Radium.ContactsPageView.create({
        templateName: 'contacts_sidebar'
      }));

      Radium.get('appController').set('feedView', Radium.ContactsPageView.create({
        controller: Radium.get('appController.contactsController')
      }));
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
  },

  loadContacts: function(manager) {
    var self = this;

    $(window).off();
    
    var lastLoadedPage = Radium.contactsController.get('totalPagesLoaded'),
        page = ++lastLoadedPage,
        isAllContactsLoaded = Radium.contactsController.get('isAllContactsLoaded');

    if (isAllContactsLoaded) {
      manager.goToState('ready');
    } else {
      manager.goToState('loading');
      var moreContacts = Radium.store.find(Radium.Contact, {page: page});
      moreContacts.addObserver('isLoaded', function() {
        if (this.get('isLoaded')) {
          manager.goToState('ready');
        }
      });
    }
  }
})
