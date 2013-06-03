Radium.PipelineRoute = Radium.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.negotiating'

  model: ->
    model = @modelFor 'pipeline'

    return model if model

    settings = @controllerFor('accountSettings')

    Ember.Deferred.promise (deferred) ->
      Radium.Deal.find({}).then( (deals) ->
        pipeline =  Radium.Pipeline.create
                          settings: settings 

        deferred.resolve pipeline
      ).then(null, (error) ->
        Ember.Logger.error(error)
        throw error
      )

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons',
      outlet: 'buttons'
      into: 'application'
