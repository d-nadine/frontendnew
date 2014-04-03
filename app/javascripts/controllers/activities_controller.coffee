Radium.ActivitiesController = Radium.ArrayController.extend
  itemController: 'activityItem'

  activities: Ember.computed.filter '@this', (item) ->
    item.get('isLoaded') && !item.get('isDeleted')

Radium.ActivityItemController = Radium.ObjectController.extend()
