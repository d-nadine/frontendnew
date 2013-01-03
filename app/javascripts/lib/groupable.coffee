Radium.Groupable = Em.Mixin.create
  groupType: Em.Object

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    addedObjects = array.slice(idx, idx + addedCount)
    for object in addedObjects
      group = @groupFor object
      group.get('content').pushObject object unless group.get('content').contains object
      groups = @get 'groups'
      unless groups.contains group
        groups.pushObject group

  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    removedObjects = array.slice(idx, idx + removedCount)
    for object in removedObjects
      group = @groupFor object
      group.get('content').removeObject object
      if group.get('content.length') == 0
        @get('groups').removeObject group

    @_super.apply(this, arguments)

  arrangedContent: (->
    if content = @get 'content'
      @group(content)
  ).property()

  group: (collection) ->
    groupsMap = {}
    groups    = Ember.A([])
    @set 'groupsMap', groupsMap
    @set 'groups',    groups

    collection.forEach ((object) ->
      group = @groupFor(object)
      group.get("content").pushObject object
    ), this

    groups

  groupFor: (object) ->
    groupsMap = @get 'groupsMap'
    groups    = @get 'groups'

    groupId = @groupBy(object)
    group = groupsMap[groupId]
    unless group
      groupType = @get 'groupType'
      group = groupType.create content: Ember.A([]), groupId: groupId
      groupsMap[groupId] = group
      groups.pushObject group

    group
