Radium.PipelineRoute = Radium.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

  activate: ->
    # FIXME: use a mixin when we upgrade to rc6
    @_super.apply this, arguments
    return if @events.hasOwnProperty 'saveChecklist'
    Ember.merge @events, Radium.ChecklistEvents

  model: ->
    model = @modelFor 'pipeline'

    return model if model

    Radium.Pipeline.create
      settings: @controllerFor('accountSettings')

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons',
      outlet: 'buttons'
      into: 'application'
