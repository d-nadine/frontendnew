require 'lib/radium/groupable'

Radium.GroupableWithDefaults = Ember.Mixin.create Radium.Groupable,
  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    removedObjects = array.slice(idx, idx + removedCount)
    for object in removedObjects
      group = @groupFor object
      group.get('content').removeObject object

    @_super.apply(this, arguments)

  group: (collection, defaults = []) ->
    groups = @_super collection

    for index in [0..defaults.length - 1]
      name = defaults[index]
      continue if groups.find (group) -> group.get('name') == name

      groupType = @get 'groupType'
      group = groupType.create content: Ember.A([]), name: name, title: name
      @get('groupsMap')[name] = group
      groups.insertAt index, group

    groups
