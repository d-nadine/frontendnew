var topBarView = Radium.TopbarView.create();
Radium.LoggedIn = Ember.State.create({
  enter: function() {
    $('#main-nav').show();
    topBarView.appendTo('#topbar');
  },
  exit: function() {
    topBarView.remove();
  },
  start: Ember.ViewState.create({
    view: Radium.LoadingView,
    start: Ember.State.create({
      enter: function(manager) {
        var contacts = Radium.store.find(Radium.Contact, {page: 0});
        
        contacts.addObserver('isLoaded', function() {
          console.log('Contacts loaded');
          Radium.contactsController.set('content', contacts);
          Ember.run.next(function() {
            manager.goToState(Radium.appController.getPath('_statePathCache'));
          });
        });
      }
    })
  }),
  dashboard: Radium.DashboardPage.create(),
  contacts: Radium.ContactsPage.create(),
  deals: Radium.DealsPage.create(),
  pipeline: Radium.PipelinePage.create(),
  campaigns: Radium.CampaignsPage.create(),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({})
});