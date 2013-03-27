Radium.ChecklistItemController = Ember.ObjectController.extend
  checklistItemIcon: ( ->
    "icon-#{@get('kind')}"
  ).property('kind')
