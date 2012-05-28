Radium.ContactsPage = Ember.State.extend({
  index: Ember.ViewState.extend({
    view: Radium.ContactsPageView,

    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {
        if (this.get('isFirstRun')) {
          var groups = Radium.store.find(Radium.Group, {page: 'all'});
          // contacts = Radium.store.find(Radium.Contact, {page: 0}),
          
          groups.addObserver('isLoaded', function() {
            Radium.groupsController.set('content', groups);
          });
          
          if (Radium.contactsController.get('length') <= 0) {
            Radium.contactsController.setProperties({
              content: Radium.store.find(Radium.Contact, {page: 1}),
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
    view: null,
    enter: function(manager) {
      var selectedContact = Radium.selectedContactController,
          view = this.get('view'),
          contactId = Radium.appController.get('params');

      if (selectedContact.get('contact') == null) {
        var contact = Radium.store.find(Radium.Contact, contactId);
        selectedContact.set('content', contact);
      }
      
      if (!selectedContact.getPath('content.feed')) {
        var contactFeed = Radium.feedController.create({
              init: function() {
                  var pastDates = this.createDateRange({limit: 100}),
                      futureDates = this.createDateRange({limit: 60, direction: 1});

                  this.set('futureDates', futureDates);
                  this.set('pastDates', pastDates);
                },
                content: [],
                _pastDateHash: {},
                oldestDateLoaded: null,
                newestDateLoaded: null,
                feedUrl: 'contacts/%@/feed/'.fmt(contactId)
            });
        
        selectedContact.setPath('content.feed', contactFeed);

      }

      this.set('view', Radium.ContactPageView.create({
          controller: contactFeed
        })
      );
      
      this._super(manager);
    },
    exit: function(manager) {
      this._super(manager);
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