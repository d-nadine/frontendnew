Radium.PipelineItemController = Em.ObjectController.extend
  isExpired: Radium.computed.daysOld('createdAt', 60)

  value: ( ->
    content = @get('content')

    if @get('content').constructor == Radium.Deal
      @get('content.value') || 0
    else
      @get('content.latestDeal.value') || 0
  ).property('content')
