Radium.PipelinePage = Ember.ViewState.extend(Radium.PageStateMixin, {
  view: Radium.PipelinePageView.create(),
  //Actions
  start: Ember.State.create(),
  addResource: function(manager, context) {
    Radium.App.setPath('loggedIn.pipeline.form.formType', context);
    manager.goToState('form');
  }
});