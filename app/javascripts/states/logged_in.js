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
    enter: function(manager) {
      $('body').addClass('loaded');
      manager.transitionTo(Radium.appController.getPath('_statePathCache'));
    }
  }),
  logout: function(manager, context) {
    manager.goToState('loggedOut');
  }
});
