Radium.DealSourcesController = Ember.Controller.extend
  needs: ['settings']
  dealSources: ( ->
    @get('controllers.settings.dealSources').map (source) ->
      Ember.Object.create
        name: source
        toString: ->
          @get('name')
  ).property('controllers.settings.dealSources')
