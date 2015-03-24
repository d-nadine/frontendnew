Radium.ApplicationController = Radium.ObjectController.extend
  needs: ['notifications']
  isSidebarVisible: false
  isTwoColumn: false
  isNotificationsOpen: Ember.computed.alias 'controllers.notifications.drawerOpen'
  today: Ember.DateTime.create()
  currentDrawer: null
  notificationCount: 0
  title: 'Radium'
  titleChanged: Ember.observer 'notificationCount', ->
    title = @get('title')
    notificationCount = @get('notificationCount')

    if notificationCount
      title = "(#{notificationCount}) #{title}"

    window.setTimeout ->
      document.title = "."
      document.title = title
    , 200
