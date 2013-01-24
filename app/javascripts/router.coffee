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

  connectForm: (name) ->
    @get('applicationController').connectOutlet "form", "mainForm"
    @get('mainFormController').connectOutlet "#{name}Form"

  disconnectForm: ->
    @get('applicationController').disconnectOutlet "form"

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

    showTodoForm: (router, event) ->
      router.connectForm "todo"

    closeForm: (router, event) ->
      router.disconnectForm()

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
