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
        var account = Radium.store.find(Radium.Account, ACCOUNT),
            users = Radium.store.find(Radium.User, {page: 0});

        users.addObserver('isLoaded', function() {
          console.log('Users loaded, go to', manager.get('_routeCache'));
          Radium.usersController.set('content', users);
          manager.send('loadSection', manager.get('_routeCache'));
        });
      }
    })
  }),
  dashboard: Radium.DashboardPage.create(),
  contacts: Ember.State.create({}),
  deals: Radium.DealsPage.create(),
  pipeline: Radium.PipelinePage.create(),
  campaigns: Radium.CampaignsPage.create({}),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({})
});