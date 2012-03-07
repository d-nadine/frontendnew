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
          console.log('Users loaded for', Radium.appController.get('_routeCache'));
          Radium.usersController.set('content', users);
          Ember.run.next(function() {
            manager.goToState(Radium.appController.getPath('_routeCache.page'));
          });
        });
      }
    })
  }),
  dashboard: Radium.DashboardPage.create(),
  contacts: Ember.State.create({}),
  deals: Radium.DealsPage.create(),
  pipeline: Radium.PipelinePage.create(),
  campaigns: Radium.CampaignsPage.create({}),
  campaign: Ember.ViewState.create(Radium.PageStateMixin, {
    view: Ember.View.create({}),
    start: Ember.State.create({
      enter: function() {
        console.log('worked!');
      }
    })
  }),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({})
});