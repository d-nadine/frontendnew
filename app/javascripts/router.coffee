Radium.Router = Ember.Router.extend
  enableLogging: true
  initialState: 'loading'
  showUser: Ember.Route.transitionTo('root.users.user')

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

  root: Ember.Route.extend
    route: '/'

    connectOutlets: (router) ->
      router.get('applicationController').connectOutlet('main')
      router.get('applicationController').connectOutlet('topbar', 'topbar')

    dashboard: Ember.Route.extend
      route: '/dashboard'

      connectOutlets: (router) ->
        sections = Radium.store.findAll(Radium.FeedSection)
        router.get('mainController').connectOutlet('content', 'feed', sections)

    users: Ember.Route.extend
      route: '/users'

      user: Ember.Route.extend
        route: '/:user_id'

        deserialize: (router, params) ->
          # fixture adapter is pretty limited and works only with integer ids
          # TODO: check if ember always assumes that id has integer type
          params.user_id = parseInt(params.user_id)
          @_super(router, params)

        connectOutlets: (router, user) ->
          router.get('mainController').connectOutlet('content', 'user', user)

  authenticated: Ember.Route.extend
    index: Ember.Route.extend
      connectOutlets: (router) ->
        if path = router.get('lastAttemptedPath')
          router.transitionTo('root')
          router.route(path)
        else
          router.transitionTo('root.dashboard')
