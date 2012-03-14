Radium.ContactsPage = Ember.State.extend({
  initialState: 'index',
  index: Ember.ViewState.extend(Radium.PageStateMixin, {
    view: Radium.ContactsPageView,
    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {
        if (this.get('isFirstRun')) {
          if (Radium.campaignsController.get('length') <= 0) {
            Radium.campaignsController.set(
              'content',
              Radium.store.findAll(Radium.Campaign, {page: 0})
            );
          }

          if (Radium.contactsController.get('length') <= 0) {
            Radium.contactsController.set(
              'content', 
              Radium.store.findAll(Radium.Contact, {page: 1})
            );
          }

          this.set('isFirstRun', false);

          Ember.run.next(function() {
            manager.goToState('ready');
          });
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),
    ready: Ember.State.create({
      enter: function(manager) {
        Radium.selectedContactsController.set('content', Radium.contactsController.get('content'));
      },
      exit: function(manager) {
        Radium.contactsController.setEach('isSelected', false);
      }
    }),

    selectedCampaign: Ember.State.create({
      exit: function(manager) {
        Radium.contactsController.setEach('isSelected', false);
        Radium.selectedContactsController.setProperties({
          content: [],
          selectedCampaign: null
        });
      }
    }),

    // Events
    allCampaigns: function(manager, context) {
      manager.goToState('ready');
    },

    selectCampaign: function(manager, context) {
      Radium.selectedContactsController.setProperties({
        content: context.get('contacts'),
        selectedCampaign: context
      });
      manager.goToState('selectedCampaign');
    }
  })
})