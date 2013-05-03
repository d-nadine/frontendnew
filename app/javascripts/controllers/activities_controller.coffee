Radium.ActivitiesController = Radium.ArrayController.extend
  lookupItemController: (activity) ->
    "activities.#{activity.get('tag')}"
