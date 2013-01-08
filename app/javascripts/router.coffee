Radium.Router = Ember.Router.extend
  location: 'none'
  enableLogging: true
  initialState: 'loading'

  init: ->
    @_super()
    @set('currentUser', 'foo')

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

        router.get('notificationsController').set('content', Radium.Notification.find())
        router.get('notificationsController').set('reminders', Radium.Reminder.find())
        router.get('applicationController').connectOutlet('notifications', 'notifications')

        router.transitionTo('root')

  root: Ember.Route.extend
    showUser: Ember.Route.transitionTo('root.users.user')
    showContacts: Ember.Route.transitionTo('root.contacts.index')
    showContact: Ember.Route.transitionTo('root.contacts.contact')
    showDeal: Ember.Route.transitionTo('root.deal')
    showCampaign: Ember.Route.transitionTo('root.campaigns.campaign')
    showGroup: Ember.Route.transitionTo('root.groups.group')
    showDashboard: Ember.Route.transitionTo('root.dashboard')
    showCalendar: Ember.Route.transitionTo('root.calendar.index')

    expandFeedItem: (router, event) ->
      router.set 'feedController.expandedItem', event.context
    scrollFeedToDate: (router, event) ->
      router.set 'feedController.currentDate', event.context

    initialState: 'dashboard'

    dashboard: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

        router.set 'dashboardFeedController.scope', router.get('currentUser')
        feed = Radium.Feed.findFor router.get('currentUser')

        router.get('mainController').connectOutlet 
          outletName: 'content'
          controller: router.get('dashboardFeedController')
          viewClass: Radium.FeedView
          context: feed

    deal: Ember.Route.extend
      route: '/deals/:deal_id'
      connectOutlets: (router, deal) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')
        router.get('mainController').connectOutlet('content', 'deal', deal)

      deserialize: (router, params) ->
        params.deal_id = parseInt(params.deal_id)

    campaigns: Ember.Route.extend
      route: '/campaigns'
      connectOutlets: (router, params) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

      campaign: Ember.Route.extend
        route: '/:campaign_id'
        connectOutlets: (router, campaign) ->
          router.get('mainController').connectOutlet('content', 'campaign', campaign)

        deserialize: (router, params) ->
          params.campaign_id = parseInt(params.campaign_id)

    groups: Ember.Route.extend
      route: '/groups'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

      group: Ember.Route.extend
        route: '/:group_id'

        deserialize: (router, params) ->
          params.group_id = parseInt(params.group_id)
          @_super(router, params)

        connectOutlets: (router, group) ->
          router.set 'groupsFeedController.scope', group

          router.set 'groupsFeedController.recordId', group.get('id')
          # FIXME: this is bullshit
          router.set 'groupsFeedController.recordType', Radium.GroupFeedSection

          feed = Radium.FeedSection.find
            scope: group
            nearDate: Ember.DateTime.create()

          router.get('mainController').connectOutlet 'content', 'groupsFeed', feed

    contacts: Ember.Route.extend
      route: '/contacts'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'contactsSidebar')
        router.get('mainController').connectOutlet('content', 'contacts')
        router.get('campaignsController').set('content', Radium.Campaign.find())

      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('contactsController').set('collection', Radium.Contact.find())

      contact: Ember.Route.extend
        route: '/:contact_id'
        connectOutlets: (router, contact) ->
          router.set 'contactsFeedController.scope', contact

          feed = Radium.FeedSection.find
            scope: contact
            nearDate: Ember.DateTime.create()

          router.get('mainController').connectOutlet 'content', 'contactsFeed', feed

          router.set 'contactsFeedController.recordId', contact.get('id')
          # FIXME: this is bullshit
          router.set 'contactsFeedController.recordType', Radium.ContactFeedSection

        deserialize: (router, params) ->
          params.contact_id = parseInt(params.contact_id)
          @_super(router, params)

    users: Ember.Route.extend
      route: '/users'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

      user: Ember.Route.extend
        route: '/:user_id'
        connectOutlets: (router, user) ->
          router.set 'usersFeedController.scope', user

          feed = Radium.FeedSection.find
            scope: user
            nearDate: Ember.DateTime.create()

          router.get('mainController').connectOutlet 'content', 'usersFeed', feed

          router.set 'usersFeedController.recordId', user.get('id')
          # FIXME: this is bullshit
          router.set 'usersFeedController.recordType', Radium.UserFeedSection

        deserialize: (router, params) ->
          # fixture adapter is pretty limited and works only with integer ids
          # TODO: check if ember always assumes that id has integer type
          params.user_id = parseInt(params.user_id)
          @_super(router, params)

    calendar: Ember.Route.extend
      route: '/calendar'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'calendarSidebar')

      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          # jumpTo(calendar: true)

      showDate: Ember.Route.transitionTo('withDate')

      withDate: Ember.Route.extend
        route: '/:date'
        connectOutlets: (router, params) ->
          params.calendar = true
          # jumpTo(params)
