Radium.DealSourcesController = Ember.Controller.extend
  needs: ['settings']
  dealSources: ( ->
    @get('controllers.settings.dealSources')
  ).property('controllers.settings.dealSources.[]')
