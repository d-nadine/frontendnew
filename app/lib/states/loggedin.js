var topBarView = Radium.TopbarView.create();
Radium.LoggedIn = Ember.State.create({
  enter: function() {
    $('#main-nav').show();
    Radium.usersController.fetchUsers();
    Radium.contactsController.fetchContacts();
    topBarView.appendTo('#topbar');

    // Fetch data
    var activities = Radium.store.findAll(Radium.Activity);
    Radium.dashboardController.set('content', activities);

    var announcements = Radium.store.findAll(Radium.Announcement);
    Radium.announcementsController.set('content', announcements);

    var deals = Radium.store.findAll(Radium.Deal);
    Radium.dealsController.set('content', deals);

    var meetings = Radium.store.findAll(Radium.Meeting);
    Radium.meetingsController.set('content', meetings);

    var callLists = Radium.store.findAll(Radium.CallList);
    Radium.callListsController.set('content', callLists);
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