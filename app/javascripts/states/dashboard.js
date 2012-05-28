Radium.DashboardPage = Ember.ViewState.extend({
    
  view: Radium.DashboardView,

  isFormAddView: false,

  index: Ember.State.create({
    firstRun: true,
    // enter: function(manager) {
      // Crossfilter feed, disabled until charts are integrated
      // Radium.dashboardFeedListController.registerFeeds([
      //   Radium.feedByKindController,
      //   Radium.feedByUserController,
      //   Radium.feedByContactController,
      //   Radium.feedByDateController,
      //   Radium.feedByActivityController
      // ]);
    // }
  }),

  ready: Ember.State.create({}),

  loading: Radium.MiniLoader,

  /**
    ACTIONS
    ------------------------------------
  */

});
