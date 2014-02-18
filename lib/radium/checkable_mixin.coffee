Radium.CheckableMixin = Ember.Mixin.create
  allChecked: false
  checkedContent: Ember.arrayComputed 'arrangedContent.@each.isChecked',
    initialValue: []

    addedItem: (array, item, changeMeta, instanceMeta) ->
      return array unless item.get('isChecked')
      return if array.contains item

      array.pushObject item

      array

    removedItem: (array, deal, changeMeta, instanceMeta) ->
      array.reject (item) -> !item.get('isChecked')

  hasCheckedContent: (->
    !Ember.isEmpty(@get('checkedContent'))
  ).property('checkedContent.length')

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (item) ->
      item.set 'isChecked', !allChecked

  allCheckedDidChange: (  ->
    @toggleChecked()
  ).observes('allChecked')
