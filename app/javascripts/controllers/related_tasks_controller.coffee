require 'lib/radium/groupable'

Radium.RelatedTasksController = Ember.ArrayController.extend Radium.Groupable,
  # FIXME: sortable mixin blitzing arrangedContent WTF!!!
  # sortProperties: ['time']

  groupBy: (task) ->
    if task.get('isFinished') then 'finished' else 'unfinished'

  sortedGroups: (->
    # get the groups to assign the internal variables
    @get 'groupedContent'

    groupsMap = @get('groupsMap')

    groupsMap['unfinished'] ||= @get('groupType').create content: Ember.A([]), name: 'unfinished'
    groupsMap['finished'] ||= @get('groupType').create content: Ember.A([]), name: 'finished'

    for name in ['unfinished', 'finished']
      group = groupsMap[name]
      if group.get('length')
        group = group.get('content').sort (a, b) ->
          Ember.DateTime.compare a.get('time'), b.get('time')

    Ember.A([
      @get('groupsMap')['unfinished']
      @get('groupsMap')['finished']
    ])
  ).property('groupedContent.[]')

