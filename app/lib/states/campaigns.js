Radium.CampaignsPage = Ember.State.extend({
  initialState: 'index',
  index: Ember.ViewState.extend(Radium.PageStateMixin, {
    view: Radium.CampaignsPageView,
    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {
        if (this.get('isFirstRun')) {
          if (Radium.campaignsController.get('length') <= 0) {
            Radium.campaignsController.set(
              'content', 
              Radium.store.find(Radium.Campaign, {page: 0})
            );
          }

          this.toggleProperty('isFirstRun');
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),
    ready: Ember.State.create()
  }),
  show: Ember.ViewState.create(Radium.PageStateMixin, {
    view: Radium.CampaignPage,
    enter: function(manager) {
      this._super(manager);
      var id = Radium.appController.getPath('params.show');
      console.log('Grabbing Campaign', id);
      Radium.selectedCampaignController.set(
        'content', 
        Radium.store.find(Radium.Campaign, id)
      );
    },
    exit: function(manager) {
      this._super(manager);
      Radium.selectedCampaignController.set('content', null);
      Radium.selectedCampaignController.set('campaignStats', {});
    },
    start: Ember.State.create({
      enter: function() {
        // Grab the static stats for the campaign, raw JSON object, no need for DS.
        var id = Radium.appController.getPath('params.show');

        $.ajax({
          url: '/api/campaigns/%@/statistics'.fmt(id),
          dataType: 'json',
          contentType: 'application/json',
          success: function(data) {
            Radium.selectedCampaignController.addStatsData(data);
          }
        });
      }
    }),
    ready: Ember.State.create()
  })
});