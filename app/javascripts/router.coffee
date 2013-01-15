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

  showUser: Ember.Route.transitionTo('root.users.user')
  showContacts: Ember.Route.transitionTo('root.contacts.index')
  showContact: Ember.Route.transitionTo('root.contacts.contact')
  showDeal: Ember.Route.transitionTo('root.deal')
  showCampaign: Ember.Route.transitionTo('root.campaigns.campaign')
  showGroup: Ember.Route.transitionTo('root.groups.group')
  showDashboard: Ember.Route.transitionTo('root.dashboard.all')
  showCalendar: Ember.Route.transitionTo('root.calendar.index')
  showInbox : Ember.Route.transitionTo('root.folders.folder.index')
  showEmail : Ember.Route.transitionTo('root.folders.folder.email')
  emailBulkAction: Em.Route.transitionTo('root.folders.folder.action')
  showFolder: Em.Route.transitionTo('root.folders.folder.index')
  #FIXME: delete after folders drawer is complete
  showFolderMenu: Em.Route.transitionTo('root.folders.folder.foldersMenu')

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

        router.get('applicationController').connectOutlet('main')
        router.get('applicationController').connectOutlet('topbar', 'topbar')
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

        router.get('notificationsController').set('content', Radium.Notification.find())
        router.get('notificationsController').set('reminders', Radium.Reminder.find())
        router.get('applicationController').connectOutlet('notifications', 'notifications')

        router.transitionTo('root')

  root: Ember.Route.extend
    showUser: Ember.Route.transitionTo('root.users.user')
    showContacts: Ember.Route.transitionTo('root.contacts.index')
    showContact: Ember.Route.transitionTo('root.contacts.contact')
    showGroup: Ember.Route.transitionTo('root.groups.group')
    showDashboard: Ember.Route.transitionTo('root.dashboard')

    showTodoForm: (router, event) ->
      router.get('applicationController').connectOutlet "form", "todoForm"

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

    folders: Em.Route.extend
      route: '/messages'
      connectOutlets: (router) ->

      folder: Em.Route.extend
        route: '/:folder_name'
        connectOutlets: (router, name) ->
          name ||= 'inbox'
          content = Radium.Email.find(folder: name)
          router.get('applicationController').connectOutlet('sidebar', 'inboxSidebar', content)
          router.get('applicationController').connectOutlet('sidebartoolbar', 'sidebarEmailToolbar')

          router.get('sidebarEmailToolbarController').connectControllers('inboxSidebar', 'inbox')
        exit: (router) ->
          router.get('applicationController').disconnectOutlet('sidebartoolbar')

        serialize: (router, folder) ->
          {folder_name: name}

        index: Em.Route.extend
          route: '/'
          connectOutlets: (router) ->
            sidebarController = router.get('inboxSidebarController')

            content = sidebarController.get('content')
            router.get('mainController').connectOutlet('content', 'inbox', content)

            router.get('inboxController').connectControllers('inboxSidebar')

            unless sidebarController.get('active')
              router.runWhenLoaded content, ->
                if content.get('length') > 0
                  active = content.get('firstObject')
                  sidebarController.setActive(active)
                  router.send('showEmail', active)
            else
              router.send('showEmail', sidebarController.get('active'))

        action: Em.Route.extend
          route: '/action'
          connectOutlets: (router) ->
            router.get('mainController').connectOutlet
              controller: router.get('inboxController')
              viewClass: Radium.BulkEmailActionView
              outletName: 'content'

        foldersMenu: Em.Route.extend
          route: 'folders_menu'
          connectOutlets: (router) ->
            router.get('mainController').connectOutlet('content', 'folders')
            router.get('foldersController').connectControllers('sidebarEmailToolbar')

        email: Em.Route.extend
          route: '/:email_id'
          connectOutlets: (router, email) ->
            history = Radium.Email.find(historyFor: email)

            router.get('inboxController').connectOutlet('emailSection', history)

            router.set 'emailSectionController.email', email
            router.set 'emailSectionController.currentPage', 1

            router.set 'inboxSidebarController.active', email

            router.get('emailSectionController').connectOutlet
              controller: router.get('emailSectionController')
              viewClass: Radium.ShowRecentEmailView
              outletName: 'showRecent'
            router.get('emailSectionController').connectOutlet
              controller: router.get('emailSectionController')
              viewClass: Radium.EmailView
            router.get('emailSectionController').connectOutlet
              controller: router.get('emailSectionController')
              viewClass: Radium.ShowMoreEmailsView
              outletName: 'showmore'

    users: Ember.Route.extend
      route: '/users'

      user: Ember.Route.extend
        route: '/:user_id'
