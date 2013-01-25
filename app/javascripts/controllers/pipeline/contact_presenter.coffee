Radium.PipelinePresenter = Em.ObjectProxy.extend
  isExpired: ( ->
    # FIXME: Arbitary cut off point
    @get('daysSinceCreation') > 60
  ).property('createdAt')

  nextTaskText: ( ->
    nextTask = @get('nextTask')

    return "" if !nextTask

    nextTask.get('description')
  ).property('nextTask')

  daysSinceText: ( ->
    daysSinceCreation = @get('daysSinceCreation')

    if daysSinceCreation <= 1
      return "1 day"

    "#{daysSinceCreation} days"
  ).property('daysSinceCreation')

