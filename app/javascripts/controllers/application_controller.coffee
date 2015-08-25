Radium.ApplicationController = Radium.ObjectController.extend
  actions:
    transitionToList: (list) ->
      @EventBus.publish 'closeDrawers'

      @transitionToRoute 'people.index', 'listed', queryParams: list: list.get('id'), hidesidebar: true

      false

  needs: ['notifications', 'lists']
  isSidebarVisible: false
  today: Ember.DateTime.create()
  notificationCount: 0
  title: 'Radium'

  showNotifications: false

  titleChanged: Ember.observer 'notificationCount', ->
    title = @get('title')
    notificationCount = @get('notificationCount')

    if notificationCount
      title = "(#{notificationCount}) #{title}"

    window.setTimeout ->
      document.title = "."
      document.title = title
    , 200

  notifications: Ember.computed.oneWay 'controllers.notifications'
  lists: Ember.computed.oneWay 'controllers.lists'
  configurableLists: Ember.computed.oneWay 'lists.configurableLists'
