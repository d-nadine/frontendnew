Radium.ApplicationController = Radium.ObjectController.extend
  actions:
    transitionToTag: (tag) ->
      @transitionToRoute 'people.index', 'tagged', queryParams: tag: tag.get('id'), hidesidebar: true

      false

  needs: ['notifications', 'tags']
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

  tags: Ember.computed.oneWay 'controllers.tags'
  configurableTags: Ember.computed.oneWay 'tags.configurableTags'
