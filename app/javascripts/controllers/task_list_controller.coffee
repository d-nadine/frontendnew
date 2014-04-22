require 'lib/radium/groupable'
require 'lib/radium/show_more_mixin'

Radium.TaskListController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  arrangedGroups: Ember.computed.sort 'groupedContent', (left, right) ->
    Ember.compare left.get('position'), right.get('position')

  groupedContent: Ember.arrayComputed 'visibleContent.[]', 'visibleContent.@each.isFinished',
    addedItem: (array, task, changeMeta, instanceMeta) ->
      name = @groupBy task

      unless group = array.findBy 'name', name

        group = Ember.ArrayProxy.create
          content: Ember.A()
          name: name

        unless group.get('name') == 'today'
          displayName = group.get('name').replace(/\_/g, ' ').split(' ').map((word) -> word.capitalize()).join(' ')

        group.set 'displayName', displayName
        group.set 'position', @getPosition(group)

        array.pushObject group

      group.pushObject task

      array

    removedItem: (array, task, changeMeta, instanceMeta) ->
      name = @groupBy task

      unless group = array.findBy 'name', name
        return

      group.removeObject task

      unless group.get('length')
        array.removeObject group

      array

  getPosition: (group) ->
    switch group.get('name')
      when 'today' then 1
      when 'tomorrow' then 2
      when 'this_week' then 3
      when 'next_week' then 4
      else 5

  groupBy: (task) ->
    today    = @get 'clock.endOfDay'
    tomorrow = @get 'clock.endOfTomorrow'
    thisWeek = @get 'clock.endOfThisWeek'
    nextWeek = @get 'clock.endOfNextWeek'
    time     = task.get 'time'

    if task.get('overdue') || time.isToday()
      'today'
    else if time.isTomorrow()
      'tomorrow'
    else if time.toJSDate() < thisWeek.toJSDate()
      'this_week'
    else if time.toJSDate() < nextWeek.toJSDate()
      'next_week'
    else
      'later'
