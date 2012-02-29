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
        console.log('bootstrap');
        this._super(Radium.App); // Pass in the StateManager
        var account = Radium.store.find(Radium.Account, ACCOUNT),
            users = Radium.store.find(Radium.User, {page: 0});
            // users = account.get('users');
        users.addObserver('isLoaded', function() {
          console.log('Users loaded, go to', manager.get('_routeCache'));
          Radium.usersController.set('content', users);
          manager.send('loadSection', manager.get('_routeCache'));
        });
      }
    })
  }),
  dashboard: Radium.DashboardState.create(),
  contacts: Ember.State.create({}),
  deals: Radium.DealsState.create(),
  pipeline: Ember.State.create({}),
  campaigns: Ember.State.create({}),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({})
});