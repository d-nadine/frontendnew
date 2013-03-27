Radium.ChecklistItemController = Ember.ObjectController.extend
  checklistItemIcon: ( ->
    "icon-#{@get('kind')}"
  ).property('kind')

  selectChecklistItem: (item) ->
    @send 'selectChecklistItem', item
