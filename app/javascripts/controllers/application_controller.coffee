Radium.ApplicationController = Radium.ObjectController.extend
  today: Ember.DateTime.create()
  currentDrawer: null
  notificationCount: ( ->
    Radium.get('notifyCount')
  ).property('Radium.notifyCount')

