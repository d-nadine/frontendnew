# Normalize arguments. Supported arguments:
#
# name
# name, context
# outletName, name
# outletName, name, context
# options
#
# The options hash has the following keys:
#
#   name: the name of the controller and view
#     to use. If this is passed, the name
#     determines the view and controller.
#   outletName: the name of the outlet to
#     fill in. default: 'view'
#   viewClass: the class of the view to instantiate
#   controller: the controller instance to pass
#     to the view
#   context: an object that should become the
#     controller's `content` and thus the
#     template's context.
Radium.Router = Ember.Router.extend Radium.RunWhenLoadedMixin,
  location: 'none'
  enableLogging: true
  initialState: 'loading'

  closeDrawer: ->
    @get('drawerController').disconnectOutlet()

  toggleDrawer: (name) ->
    if @get('drawerController.view')
      @closeDrawer()
    else
      @get('drawerController').connectOutlet name

  connectDrawerButtons: (name) ->
    @get('drawerController').connectOutlet
      outletName: 'buttons'
      controller: @get('drawerController')
      viewClass: Radium.get "#{name.capitalize()}DrawerButtonsView"

  disconnectDrawerButtons: ->
    @get('drawerController').disconnectOutlet 'buttons'

  connectForm: (name) ->
    @get('applicationController').connectOutlet "form", "mainForm"
    @get('mainFormController').connectOutlet "#{name}Form"

  disconnectForm: ->
    @get('applicationController').disconnectOutlet "form"

  connectFeed: (scope, controller) ->
    controllerName = "#{controller}Controller"

    feed = Radium.Feed.create scope: scope

    @get('mainController').connectOutlet 
      outletName: 'content'
      controller: @get controllerName
      viewClass: Radium.FeedView
      context: feed

    @get('applicationController').connectOutlet('sidebar', 'sidebar')

    @get('sidebarController').connectOutlet 
      outletName: 'filters'
      controller: @get controllerName
      viewClass: Radium["#{controller.capitalize()}FilterView"]

    @set('activeFeedController', @get(controllerName))

  loading: Ember.Route.extend
    # overwrite routePath to not allow default behavior
    # Ember.Router does not support cancelling routing, which prevents
    # from doing authentication easily - if a user hits url, it will
    # go there by default. We need to overwrite this behavior to check
    # authentication and then redirect to correct state
    # TODO: fix when ember is updated
    routePath: (router, path) ->
      if router.get('currentUser')
        router.transitionTo('authenticated.index')
      else
        router.transitionTo('unauthenticated.index')

  switchToUnauthenticated: Ember.State.transitionTo('unauthenticated.index')
  switchToAuthenticated: Ember.State.transitionTo('authenticated.index')

  unauthenticated: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.transitionTo('login')

    login: Ember.Route.extend
      route: '/login'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('login')

  authenticated: Ember.Route.extend
    route: '/authenticated'
    index: Ember.Route.extend
      connectOutlets: (router) ->
        router.set 'usersController.content', Radium.User.find()

        router.get('applicationController').connectOutlet 'main'
        router.get('applicationController').connectOutlet 'topbar', 'topbar' 
        router.get('applicationController').connectOutlet 'sidebar', 'sidebar' 
        router.get('applicationController').connectOutlet 'drawer', 'drawer'

        # router.get('notificationsController').set('content', Radium.Notification.find())
        # router.get('notificationsController').set('reminders', Radium.Reminder.find())
        # router.get('applicationController').connectOutlet('notifications', 'notifications')

        router.transitionTo('root')

  root: Ember.Route.extend
    showDashboard: Ember.Route.transitionTo('root.dashboard')
    showUser: Ember.Route.transitionTo('root.users.user')
    showContact: Ember.Route.transitionTo('root.contacts.contact')
    emailBulkAction: Em.Route.transitionTo('root.messages.folder.action')
    showMessages: Em.Route.transitionTo('root.messages.folder')

    showNotifications: (router, event) ->
      router.get('drawerController').connectOutlet "stack"

    showTodoForm: (router, event) ->
      router.connectForm "todo"

    closeForm: (router, event) ->
      router.disconnectForm()

    expandFeedItem: (router, event) ->
      router.set 'activeFeedController.expandedItem', event.context
    scrollFeedToDate: (router, event) ->
      router.set 'activeFeedController.currentDate', event.context

    initialState: 'dashboard'

    dashboard: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.connectFeed router.get('currentUser'), 'dashboardFeed'

    groups: Ember.Route.extend
      route: '/groups'

      group: Ember.Route.extend
        route: '/:group_id'

    contacts: Ember.Route.extend
      route: '/contacts'

      index: Ember.Route.extend
        route: '/'

      contact: Ember.Route.extend
        route: '/:contact_id'

    messages: Em.Route.extend
      route: '/messages'

      toggleFolderDrawer: (router, event) ->
        router.toggleDrawer "folders"

      folder: Em.Route.extend
        route: '/:folder'

        serialize: (router, name) ->
          { folder: name }

        connectOutlets: (router, folder) ->
          router.closeDrawer()

          router.connectDrawerButtons 'inbox'

          content = Radium.Email.find folder: folder

          router.set 'inboxController.folder', folder
          router.set 'inboxController.content', content

          router.get('mainController').connectOutlet 'inbox'

          router.get('applicationController').connectOutlet 'sidebar', 'inboxSidebar'
          router.get('applicationController').connectOutlet 'sidebartoolbar', 'sidebarEmailToolbar'

          router.get('inboxSidebarController').connectControllers 'inbox'
          router.get('emailPanelController').connectControllers 'inbox'
          router.get('bulkEmailActionsController').connectControllers 'inbox'
          router.get('sidebarEmailToolbarController').connectControllers 'inboxSidebar', 'inbox'

        exit: (router) ->
          router.disconnectDrawerButtons()

          router.set 'inboxController.folder', null
          router.set 'inboxController.content', null

          router.get('mainController').disconnectOutlet()

          router.get('applicationController').disconnectOutlet 'sidebar'
          router.get('applicationController').disconnectOutlet 'sidebartoolbar'


    users: Ember.Route.extend
      route: '/users'

      user: Ember.Route.extend
        route: '/:user_id'
