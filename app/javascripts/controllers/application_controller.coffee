Radium.ApplicationController = Radium.ObjectController.extend
  actions:
    transitionToTag: (tag) ->
      @transitionToRoute 'people.index', 'tagged', queryParams: tag: tag.get('id'), hidesidebar: true

      false

  needs: ['notifications', 'tags']
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
  tags: Ember.computed.oneWay 'controllers.tags'
  configurableTags: Ember.computed.oneWay 'tags.configurableTags'
