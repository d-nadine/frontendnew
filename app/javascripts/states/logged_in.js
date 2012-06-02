Radium.LoggedIn = Ember.State.extend({
  enter: function(manager) {
    $('#main-nav').show();

    manager.get('rootView').remove();

    manager.set('rootView', Ember.ContainerView.create({
      childViews: ['topBar', 'loading', 'content'],
      topBar: Radium.TopbarView,
      loading: Radium.LoadingView,
      content: Ember.View.create({
        controller: Radium.get('appController'),
        templateName: 'main_dash',
        sideBarBinding: 'controller.sideBarView',
        feedViewBinding: 'controller.feedView'
      })
    }));

    manager.get('rootView').appendTo('#main');
  },
  exit: function() {
    $('body').removeClass('loaded');
  },
  start: Ember.State.extend({
    // view: Radium.LoadingView,
    enter: function(manager) {
      $('body').addClass('loaded');
      Ember.run.next(function(){
        manager.transitionTo(Radium.appController.getPath('_statePathCache'));
      });
    }
  }),
  dashboard: Radium.DashboardPage,
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
