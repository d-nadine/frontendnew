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

  nextTaskText: ( ->
    nextTask = @get('nextTask')

    return "" if !nextTask

    if nextTask.constructor == Radium.Todo
      nextTask.get('description')
    else
      nextTask.get('topic')
  ).property('nextTask')

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
    todos = @get('todos')
    meetings = @get('meetings')
    return null if todos.get('length') == 0 && meetings.get('length') == 0

    tasks = Ember.A()
    tasks.pushObjects(todos.toArray())
    tasks.pushObjects(meetings.toArray())

    tasks.sort (a, b) ->
      sortA = if a.constructor == Radium.Meeting then a.get('startDate') else a.get('finishBy')
      sortB = if b.constructor == Radium.Meeting then b.get('startDate') else b.get('finishBy')
      Ember.DateTime.compareDate(sortA, sortB)

    tasks.get('firstObject')
  ).property('meetings', 'meetings.length', 'todos', 'todos.length')
