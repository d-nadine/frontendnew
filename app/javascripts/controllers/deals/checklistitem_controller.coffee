Radium.ChecklistItemController = Ember.ObjectController.extend
  isAdditional: ( ->
    @get('kind') == 'additional'
  ).property('kind')

  removeAdditionalItem: (item) ->
    item.get('checklist.checklistItems').removeObject item
