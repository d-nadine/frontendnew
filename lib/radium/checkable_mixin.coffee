Radium.CheckableMixin = Ember.Mixin.create
  allChecked: false
  checkedContent: Ember.arrayComputed 'arrangedContent', 'arrangedContent.@each.isChecked', {
    initialValue: []
    addedItem: (array, item, changeMeta, instanceMeta) ->
      return unless item.get('isChecked')
      array.pushObject item
      array
    removedItem: (array, item, changeMeta, instanceMeta) ->
      array.filter (item) -> item.get('isChecked')
  }

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
