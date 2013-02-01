Radium.PipelineItemController = Em.ObjectController.extend
  isExpired: ( ->
    # FIXME: Arbitary cut off point
    @get('daysSinceCreation') > 60
  ).property('createdAt')

  value: ( ->
    content = @get('content')

    if @get('content').constructor == Radium.Deal
      @get('content.value') || 0
    else
      @get('content.latestDeal.value') || 0
  ).property('content')

  daysSinceCreation: ( ->
    today = Ember.DateTime.create()
    createdAt = @get('createdAt')

    createdAt.differenceInDays(today)
  ).property('createdAt')

  daysSinceText: ( ->
    daysSinceCreation = @get('daysSinceCreation')

    if daysSinceCreation <= 1
      return "1 day"

    "#{daysSinceCreation} days"
  ).property('daysSinceCreation')

  nextTask: ( ->
    nextTask = @get('model.nextTask')
    return null unless nextTask

    if nextTask.description
      nextTask.description
    else
      nextTask.topic
  ).property('nextTask')
