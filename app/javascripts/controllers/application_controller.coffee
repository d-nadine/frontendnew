Radium.ApplicationController = Radium.ObjectController.extend
  needs: ['notifications']
  isSidebarVisible: false
  isTwoColumn: false
  isNotificationsOpen: Ember.computed.alias 'controllers.notifications.drawerOpen'
  today: Ember.DateTime.create()
  currentDrawer: null
  notificationCount: Ember.computed 'Radium.notifyCount', ->
    Radium.get('notifyCount')
