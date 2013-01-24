Radium.Router = Ember.Router.extend
  location: 'none'
  enableLogging: true
  initialState: 'loading'

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

        router.get('applicationController').connectOutlet 'topbar', 'topbar' 

        router.get('notificationsController').set('content', Radium.Notification.find())
        router.get('notificationsController').set('reminders', Radium.Reminder.find())

        router.transitionTo('root')

  root: Ember.Route.extend
    showDashboard: Ember.Route.transitionTo('root.dashboard')
    showUser: Ember.Route.transitionTo('root.user')
    showContact: Ember.Route.transitionTo('root.contact')
    showMessages: Em.Route.transitionTo('root.messages.folder')

    initialState: 'dashboard'

    dashboard: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet viewClass: Radium.UnimplementedView

      exit: (router) ->
        router.get('applicationController').disconnectOutlet()

    contact: Ember.Route.extend
      route: '/contacts/:contact_id'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet viewClass: Radium.UnimplementedView

      exit: (router) ->
        router.get('applicationController').disconnectOutlet()

    user: Ember.Route.extend
      route: '/users/:contact_id'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet viewClass: Radium.UnimplementedView

      exit: (router) ->
        router.get('applicationController').disconnectOutlet()

    messages: Em.Route.extend
      route: '/messages'

      folder: Em.Route.extend
        route: '/:folder'

        serialize: (router, name) ->
          { folder: name }

        connectOutlets: (router, folder) ->
          content = Radium.Email.find folder: folder

          router.set 'inboxController.folder', folder
          router.set 'inboxController.content', content

          router.get('applicationController').connectOutlet 'inbox'

          router.get('applicationController').connectOutlet 'drawerPanel', 'drawerPanel'
          router.get('drawerPanelController').connectOutlet 'buttons', 'inboxDrawerButtons'

          router.get('inboxController').connectOutlet 'sidebar', 'inboxSidebar'

          router.get('inboxSidebarController').connectControllers 'inbox'
          router.get('emailPanelController').connectControllers 'inbox'
          router.get('bulkEmailActionsController').connectControllers 'inbox'
          router.get('inboxDrawerButtonsController').connectControllers 'inbox', 'drawerPanel'

        exit: (router) ->
          router.get('drawerPanelController').disconnectOutlet()
          router.get('drawerPanelController').disconnectOutlet 'buttons'

          router.get('applicationController').disconnectOutlet()

          router.set 'inboxController.folder', null
          router.set 'inboxController.content', null
