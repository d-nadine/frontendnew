Radium.CampaignsPage = Ember.State.extend(Radium.PageStateMixin, {
  initialState: 'index',
  index: Ember.ViewState.extend({
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
  }),
  show: Ember.ViewState.create({
    view: Ember.View.create({
      template: Ember.Handlebars.compile('oh hi')
    }),
    start: Ember.State.create({
      enter: function() {
        
      }
    }),
    ready: Ember.State.create()
  })
});