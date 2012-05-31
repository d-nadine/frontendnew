Radium.LoggedIn = Ember.State.create({
  enter: function(manager) {
    $('#main-nav').show();
    Radium.set('topbarController', Radium.TopbarController.create());

    appController = Radium.get('appController');

    appController.set('view', Ember.View.create({
      controller: appController,
      templateName: 'main-dash' 
    }));

    rootView = Ember.ContainerView.create({
      controller: Radium.get('appController'),
      currentViewBinding: 'controller.view',
      sideBarBinding: 'controller.sideBarView',
      feedViewBinding: 'controller.feedView' 
    });

    rootView.appendTo('body');
  },
  exit: function() {
    topBarView.remove();
    $('body').removeClass('loaded');
  },
  start: Ember.ViewState.create({
    view: Radium.LoadingView,
    enter: function(manager) {
      this._super(manager);
      $('body').addClass('loaded');
      //TODO: Why delay? animation?
      Ember.run.next(function() {
        manager.goToState(Radium.appController.getPath('_statePathCache'));
      });
    }
  }),
  dashboard: Radium.DashboardPage.create(),
  // contacts: Radium.ContactsPage.create(),
  // users: Radium.UsersPage.create(),
  // deals: Radium.DealsPage.create(),
  // pipeline: Radium.PipelinePage.create(),
  // campaigns: Radium.CampaignsPage.create(),
  // calendar: Ember.State.create({}),
  // messages: Ember.State.create({}),
  // settings: Ember.State.create({}),
  // noData: Ember.ViewState.create({
  //   view: Ember.View.extend({
  //     templateName: 'error_page'
  //   })
  // }),

  // Actions
  logout: function(manager, context) {
    manager.goToState('loggedOut');
  }
});
