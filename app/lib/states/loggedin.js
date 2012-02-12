var topBarView = Radium.TopbarView.create();
Radium.LoggedIn = Ember.State.create({
  enter: function() {
    $('#main-nav').show();
    Radium.usersController.fetchUsers();
    Radium.contactsController.fetchContacts();
    topBarView.appendTo('#topbar');
  },
  exit: function() {
    topBarView.remove();
  },
  dashboard: Radium.DashboardState.create(),
  contacts: Ember.State.create({}),
  deals: Radium.DealsState.create(),
  pipeline: Ember.State.create({}),
  campaigns: Ember.State.create({}),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({})
});