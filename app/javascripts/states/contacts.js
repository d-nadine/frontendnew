Radium.ContactsPage = Ember.State.extend({
  index: Ember.ViewState.extend({
    view: Radium.ContactsPageView,

    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {
        if (this.get('isFirstRun')) {
          if (Radium.campaignsController.get('length') <= 0) {
            Radium.campaignsController.set(
              'content',
              Radium.store.findAll(Radium.Campaign)
            );
          }

          var groups = Radium.store.find(Radium.Group, {page: 0});
          // contacts = Radium.store.find(Radium.Contact, {page: 0}),
          
          groups.addObserver('isLoaded', function() {
            Radium.groupsController.set('content', groups);
          });
          
          if (Radium.contactsController.get('length') <= 0) {
            Radium.contactsController.setProperties({
              content: Radium.store.findAll(Radium.Contact),
              totalPages: 1
            });
          }
          
          this.set('isFirstRun', false);

          Ember.run.next(function() {
            manager.send('allCampaigns');
          });
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),

    ready: Ember.State.create(),

    // Loader for infinite scrolling
    loading: Radium.MiniLoader,
  }),
  
  show: Ember.ViewState.extend({
    view: Radium.ContactPageView,
    enter: function(manager) {
      var selectedContact = Radium.selectedContactController,
          contactId;

      if (selectedContact.get('contact') == null) {
        var contact = Radium.store.find(Radium.Contact, Radium.appController.get('params'));
        selectedContact.set('content', contact);
      }
      
      contactId = selectedContact.getPath('content.id');

      if (!selectedContact.getPath('content.feed')) {
        var contactFeed = Radium.feedController.create({
              content: [],
              dates: {},
              page: 0,
              totalPages: 2
            });
        
        selectedContact.setPath('content.feed', contactFeed);
      }

      this._super(manager);

      Radium.PhoneNumber.reopenClass({
        url: 'contacts/%@'.fmt(contactId),
        root: 'contact'
      });
    },
    exit: function(manager) {
      this._super(manager);
      Radium.PhoneNumber.reopenClass({
        url: null,
        root: null
      });
      Radium.selectedContactController.set('content', null);
    },
    ready: Ember.State.create(),
    loading: Radium.MiniLoader
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