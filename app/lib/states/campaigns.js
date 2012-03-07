Radium.CampaignsPage = Ember.ViewState.extend(Radium.PageStateMixin, {
  view: Radium.CampaignsPageView,
  start: Ember.State.create({
    isFirstRun: true,
    enter: function(manager) {
      if (this.get('isFirstRun')) {
        var campaigns = Radium.store.find(Radium.Campaign, {page: 0});
        Radium.campaignsController.set('content', campaigns);
        this.toggleProperty('isFirstRun');
      } else {
        Ember.run.next(function() {
          manager.goToState('ready');
        });
      }
    }
  }),

  ready: Ember.State.create()
});