Radium.PipelineItemController = Em.ObjectController.extend
  isExpired: Radium.computed.daysOld('createdAt', 60)

  value: ( ->
    content = @get('content')

    if @get('content').constructor == Radium.Deal
      @get('content.value') || 0
    else
      @get('content.latestDeal.value') || 0
  ).property('content')

  nextTask: ( ->
    nextTask = @get('model.nextTask')
    return null unless nextTask

    if nextTask.description
      nextTask.description
    else
      nextTask.topic
  ).property('nextTask')
