require 'lib/radium/groupable'

Radium.RelatedTasksController = Ember.ArrayController.extend Radium.Groupable,
  sortProperties: ['time']

  groupBy: (task) ->
    if task.get('isFinished') then 'finished' else 'unfinished'

  sortedGroups: (->
    # get the groups to assign the internal variables
    @get 'groupedContent'

    groupsMap = @get('groupsMap')

    groupsMap['unfinished'] ||= @get('groupType').create content: Ember.A([]), name: 'unfinished'
    groupsMap['finished'] ||= @get('groupType').create content: Ember.A([]), name: 'finished'

    @get('groupsMap')['unfinished'] 

    Ember.A([
      @get('groupsMap')['unfinished']
      @get('groupsMap')['finished']
    ])
  ).property('groupedContent')

