require 'lib/radium/groupable'
require 'lib/radium/show_more_mixin'

Radium.TaskListGroupItemController = Radium.ArrayController.extend
  itemController: 'taskListItem'

  title: (->
    @get('content.name').capitalize()
  ).property('content.name')

Radium.TaskListItemController = Radium.ObjectController.extend
  showMeetingForm: (->
    @get('model.constructor') is Radium.Meeting
  ).property('model')

  showTodoForm: (->
    @get('model.constructor') is Radium.Todo
  ).property('model')

  showCallForm: (->
    @get('model.constructor') is Radium.Call
  ).property('model')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    content: @get('model')
  ).property('model')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    description: null
    reference: @get('model')
  ).property('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    location: ""
    content: @get('model')
    invitations: Ember.A()
  ).property('model')

Radium.TaskListController = Radium.ArrayController.extend Radium.Groupable, Radium.ShowMoreMixin,
  # FIXME: I have a feeling this is broken, but defining
  # arrangedContent is the only way to get everything working
  arrangedContent: (->
    content = @get('content')

    return unless content

    today = @get 'clock.atBeginningOfDay'

    displayable = content.filter (item) ->
      Ember.DateTime.compare(item.get('time'), today) >= 0 || item.get('isOverdue')

    displayable.sort (item1, item2) ->
      Ember.compare item1.get('time'), item2.get('time')
  ).property('content.[]', 'clock.now')

  groupedContent: (->
    # FIXME: we want to dispose of models in an isError state,
    # this filter should be removed and the @each dependentKey should
    # be removed when the model can be destroyed
    visibleContent = @get('visibleContent').filter (item) -> !item.get('isError')

    return unless visibleContent

    @group visibleContent
  ).property('visibleContent.length', 'visibleContent.@each.isError')

  arrangedGroups: (->
    return unless @get('groupedContent')

    @get('groupedContent').forEach (group) ->
      position = switch group.get('name')
        when 'overdue' then 1
        when 'today' then 2
        when 'tomorrow' then 3
        when 'this_week' then 4
        when 'next_week' then 5
        else 6

      group.set 'position', position

    @get('groupedContent').sort (item1, item2) ->
      Ember.compare item1.get('position'), item2.get('position')
  ).property('groupedContent')

  groupBy: (task) ->
    debugger if task.get('isLoading')
    today    = @get 'clock.endOfDay'
    tomorrow = @get 'clock.endOfTomorrow'
    thisWeek = @get 'clock.endOfThisWeek'
    nextWeek = @get 'clock.endOfNextWeek'
    time     = task.get 'time'

    if task.get('isOverdue')
      'overdue'
    else if Ember.DateTime.compare(time, today) == -1
      'today'
    else if Ember.DateTime.compare(time, tomorrow) == -1
      'tomorrow'
    else if Ember.DateTime.compare(time, thisWeek) == -1
      'this_week'
    else if Ember.DateTime.compare(time, nextWeek) == -1
      'next_week'
    else
      'later'
