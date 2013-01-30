Radium.PipelineStatusItemController = Ember.ObjectController.extend
  needs: ['pipelineStatus']

  statusText: ( ->
    path = "#{@get("name")}Total"
    total = @get("controllers.pipelineStatus.#{path}")
    "#{@get("label")} (#{total})"
  ).property('model')
