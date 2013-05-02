Radium.ActivitiesController = Radium.ArrayController.extend
  sortProperties: ['timestamp']
  sortAscending: false

  lookupItemController: (activity) ->
    "activities.#{activity.get('tag')}"
