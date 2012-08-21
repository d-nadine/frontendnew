Radium.Router = Ember.Router.extend
  enableLogging: true
  initialState: 'loading'

  init: ->
    @_super()

    @set('meController', Radium.MeController.create())

  loading: Ember.Route.extend
    # overwrite routePath to not allow default behavior
    # Ember.Router does not support cancelling routing, which prevents
    # from doing authentication easily - if a user hits url, it will
    # go there by default. We need to overwrite this behavior to check
    # authentication and then redirect to correct state
    # TODO: fix when ember is updated
    routePath: (router, path) ->
      router.set('lastAttemptedPath', path)
      router.get('meController').fetch()

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
    index: Ember.Route.extend
      enter: (router) ->
        router.transitionTo('main.dashboard')

  main: Ember.Route.extend
    route: '/'

    connectOutlets: (router) ->
      router.get('applicationController').connectOutlet('main')
      router.get('applicationController').connectOutlet('topbar', 'topbar')

    dashboard: Ember.Route.extend
      route: '/dashboard'

      connectOutlets: (router) ->
        sections = Radium.store.findAll(Radium.FeedSection)
        router.get('mainController').connectOutlet('content', 'feed', sections)

