Radium.ActivitiesController = Radium.ArrayController.extend
  lookupItemController: (activity) ->
    if activity.get('isLoaded')
      "activities.#{activity.get('tag')}"
    else
      "activities.loading"
