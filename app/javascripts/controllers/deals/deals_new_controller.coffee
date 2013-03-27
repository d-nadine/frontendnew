Radium.DealsNewController = Ember.ObjectController.extend
  selectChecklistItem: (checklistItem) ->
    @set 'selectedCheckboxItem', checklistItem
