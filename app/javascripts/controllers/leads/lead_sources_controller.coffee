Radium.LeadSourcesController = Ember.Controller.extend
  needs: ['settings']
  leadSources: ( ->
    @get('controllers.settings.leadSources')
  ).property('controllers.settings.leadSources.[]')
