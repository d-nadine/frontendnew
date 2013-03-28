Radium.DealsNewController = Ember.ObjectController.extend
  selectChecklistItem: (checklistItem) ->
    @set 'selectedCheckboxItem', checklistItem

  total: ( ->
    total = 0

    @get('checklist.checklistItems').forEach (item) ->
      total += item.get('weight') if item.get('isFinished')

    total
  ).property('checklist.checklistItems.@each.isFinished')
