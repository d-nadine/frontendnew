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
          this.toggleProperty('isFirstRun');
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),
    ready: Ember.State.create()
  })
})