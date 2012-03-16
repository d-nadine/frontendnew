Radium.ContactsPage = Ember.State.extend({
  initialState: 'index',
  index: Ember.ViewState.extend(Radium.PageStateMixin, {
    view: Radium.ContactsPageView,
    exit: function(manager) {
      this._super(manager);
      $(window).off('scroll');
    },
    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {

        $(window).on('scroll', function(){
          if ($(window).scrollTop() == $(document).height() - $(window).height()) {
           Radium.contactsController.loadPage();
           console.log('more....');
          }
        });


        if (this.get('isFirstRun')) {
          if (Radium.campaignsController.get('length') <= 0) {
            Radium.campaignsController.set(
              'content',
              Radium.store.findAll(Radium.Campaign, {page: 0})
            );
          }

          if (Radium.contactsController.get('length') <= 0) {
            Radium.contactsController.setProperties({
              content: Radium.store.findAll(Radium.Contact, {page: 1}),
              totalPagesLoaded: 1
            });
          }

          this.set('isFirstRun', false);

          Ember.run.next(function() {
            Radium.selectedContactsController.setProperties({
              content: Radium.contactsController.get('content'),
              selectedCampaign: null
            });
            manager.goToState('ready');
          });
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),
    ready: Ember.State.create(),

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
      Radium.contactsController.clearSelected();
      Radium.selectedContactsController.setProperties({
        content: context.get('contacts'),
        selectedCampaign: context
      });
      manager.goToState('ready');
    }
  })
})