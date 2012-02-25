var topBarView = Radium.TopbarView.create();
Radium.LoggedIn = Ember.State.create({
  enter: function() {
    $('#main-nav').show();
    topBarView.appendTo('#topbar');
  },
  exit: function() {
    topBarView.remove();
  },
  start: Ember.State.create({
    enter: function(manager) {
      console.log('bootstrap');
      var account = Radium.store.find(Radium.Account, ACCOUNT),
          users = Radium.store.find(Radium.User, {page: 1});

      users.addObserver('isLoaded', function() {
        console.log('Users loaded, go to', manager.get('_routeCache'));
        manager.send('loadSection', manager.get('_routeCache'));
        Radium.usersController.set('content', users);
      });
    }
  }),
  loading: Ember.ViewState.create({
    view: Ember.View.create({
      template: Ember.Handlebars.compile('LOADING')
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