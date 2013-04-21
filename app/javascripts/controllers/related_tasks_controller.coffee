require 'lib/radium/groupable'

Radium.RelatedTasksController = Ember.ArrayController.extend Radium.Groupable,
  sortProperties: ['time']

  groupBy: (task) ->
    if task.get('isFinished') then 'finished' else 'unfinished'

  sortedGroups: (->
    # get the groups to assign the internal variables
    @get 'groupedContent'

    Ember.A([
      @get('groupsMap')['unfinished']
      @get('groupsMap')['finished']
    ])
  ).property('groupedContent')

