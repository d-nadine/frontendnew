function infiniteLoading() {
  if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    Radium.App.send('loadContacts');
    return false;
  }
}

Radium.ContactsPage = Ember.State.extend({
  initialState: 'index',
  index: Ember.ViewState.extend(Radium.PageStateMixin, {
    view: Radium.ContactsPageView,
    exit: function(manager) {
      this._super(manager);
      $(window).off();
    },
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
    loading: Ember.State.create({
      miniLoader: $('<div id="mini-loader" class="alert alert-block"><h4 class="alert-heading">Loading &hellip;</h4></div>').hide(),
      enter: function() {
        this.get('miniLoader').appendTo($('body')).fadeIn();
      },
      exit: function() {
        $('#mini-loader').fadeOut(function() {
          $(this).remove();
        });
      }
    })
  }),

  // Events
  allCampaigns: function(manager, context) {
    $(window).on('scroll', infiniteLoading);
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
          $(window).on('scroll', infiniteLoading);
          manager.goToState('ready');
        }
      });
    }
  }
})