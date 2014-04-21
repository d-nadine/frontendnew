require 'lib/radium/groupable'
require 'lib/radium/show_more_mixin'

Radium.TaskListController = Radium.ArrayController.extend
  arrangedContent: Ember.computed 'content.[]', ->
    content = @get('content')

    return Ember.A() unless content.get('length')

    content

  arrangedGroups: Ember.computed.sort 'groupedContent', (left, right) ->

  groupedContent: Ember.arrayComputed '@this', 'arrangedContent.@each.isFinished',
    addedItem: (array, task, changeMeta, instanceMeta) ->
      name = @groupBy task

      unless group = array.findBy 'name', name

        group = Ember.ArrayProxy.createWithMixins Radium.ShowMoreMixin,
          perPage: 3
          content: Ember.A()
          name: name

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

    Ember.compare left.get('position'), right.get('position')

  getPosition: (group) ->
    switch group.get('name')
      when 'today' then 1
      when 'overdue' then 2

  groupBy: (task) ->
    today    = @get 'clock.endOfDay'
    tomorrow = @get 'clock.endOfTomorrow'
    thisWeek = @get 'clock.endOfThisWeek'
    nextWeek = @get 'clock.endOfNextWeek'
    time     = task.get 'time'

    if task.get('overdue')
      'overdue'
    else if task.get('isFinished')
      'completed'
    else if Ember.DateTime.compare(time, today) == 0
      'today'
    else if Ember.DateTime.compare(time, tomorrow) == 0
      'tomorrow'
    else if Ember.DateTime.compare(time, thisWeek) == 0
      'this_week'
    else if Ember.DateTime.compare(time, nextWeek) == 0
      'next_week'
    else
      'later'
