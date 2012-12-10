# TODO: move all that helpers somewhere
#
# TODO such checking if date is loaded needs to be changed
#      to work properly with grouped feed sections
sectionLoaded = (date) ->
  if content = Radium.get('currentFeedController.content')
    section = content.find (s) -> s.get('id') == date
    if section
      Radium.get('currentFeedController').findRelatedSection section

findNearBy = (date) ->
  if content = Radium.get('currentFeedController.content')
    nearBy = content.find (section, i, collection) ->
      nextSection = collection.objectAt(i + 1)
      if nextSection
        section.dateBetween date, nextSection

  if nearBy
    Radium.get('currentFeedController').findRelatedSection nearBy

jumpToDate = (date) ->
  jumpTo date: date.toDateFormat()

jumpTo = (query) ->
  query   ?= {}

  if query.date && query.date.toDateFormat
    query.date = query.date.toDateFormat()

  if query.date && (section = sectionLoaded(query.date))
    if !query.disableScroll
      Radium.Utils.scroll(section.get('domClass'))
  else if query.date && (nearBy = findNearBy(query.date))
    if !query.disableScroll
      Radium.Utils.scroll("feed_section_#{nearBy.get('id')}")
  else
    sections = Radium.get('router.store').expandableArrayFor Radium.FeedSection
    sections.load Radium.FeedSection.find(query)

    if query.calendar
      # TODO: this methods has too many concerns, it would be nice to refactor it later
      Radium.router.get('mainController').connectOutlet('content', 'calendarFeed', sections)
    else if query.type
      plural = query.type.pluralize()
      type   = Radium["#{query.type.camelize().capitalize()}FeedSection"]

      Radium.router.get('mainController').connectOutlet('content', "#{plural}Feed", sections)
      Radium.router.set("#{plural}FeedController.recordId", query.id)
      Radium.router.set("#{plural}FeedController.recordType", type)
      Radium.router.set("#{plural}FeedController.type", query.type)
    else
      Radium.router.get('mainController').connectOutlet('content', 'feed', sections)

    if query.disableScroll
      Radium.get('currentFeedController').disableScroll()
    else
      Radium.Utils.scrollWhenLoaded(sections, "feed_section_#{query.date}")

  if date = query.date
    Radium.set 'currentFeedController.currentDate', date
  else if ! Radium.get('currentFeedController.currentDate')
    # set current date if no date is set yet
    Radium.set 'currentFeedController.currentDate', Ember.DateTime.create()

Radium.Router = Ember.Router.extend
  location: 'none'
  enableLogging: true
  initialState: 'loading'

  showUser: Ember.Route.transitionTo('root.users.user')
  showContacts: Ember.Route.transitionTo('root.contacts.index')
  showContact: Ember.Route.transitionTo('root.contacts.contact')
  showDeal: Ember.Route.transitionTo('root.deal')
  showCampaign: Ember.Route.transitionTo('root.campaigns.campaign')
  showGroup: Ember.Route.transitionTo('root.groups.group')
  showDashboard: Ember.Route.transitionTo('root.dashboard.all')
  showCalendar: Ember.Route.transitionTo('root.calendar.index')

  showDate: Ember.Route.transitionTo('root.dashboardWithDate')

  jumpTo: ->
    jumpTo.apply this, arguments

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

  authenticated: Ember.Route.extend
    index: Ember.Route.extend
      connectOutlets: (router) ->
        router.transitionTo('root')

        path = router.get('lastAttemptedPath')
        if path && path != '/'
          router.route(path)

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
    initialState: 'dashboard'
    connectOutlets: (router) ->
      # TODO: I would have thought that going from one action in the root.
      #       state to the other one would not trigger connectOutlets for
      #       root, investigate why that happens and where to put things
      #       that should be done only once, unless you changet the parent state
      unless router.get('initialized')
        usersController = Radium.UsersController.create()
        usersController.set 'content', router.get('store').findAll(Radium.User)
        router.set 'usersController', usersController

        router.get('applicationController').connectOutlet('main')
        router.get('applicationController').connectOutlet('topbar', 'topbar')

        router.get('notificationsController').set('content', Radium.Notification.find())
        router.get('notificationsController').set('reminders', Radium.Reminder.find())
        router.get('notificationsController').set('messages', Radium.Message.find())

        router.set('initialized', true)

    dashboard: Ember.Route.extend
      route: '/'
      initialState: 'all'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')
        jumpTo()

      all: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('feedController').set('typeFilter', null)

    # TODO: find out what's the best pattern to handle such things
    dashboardWithDate: Ember.Route.extend
      route: '/dashboard/:date'
      connectOutlets: (router, params) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')
        jumpTo(params)

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
        initialState: 'index'

        deserialize: (router, params) ->
          params.group_id = parseInt(params.group_id)
          @_super(router, params)

        connectOutlets: (router, group) ->
          jumpTo(type: 'group', id: group.get('id'))

        index: Ember.Route.extend
          route: '/'

        showDate: Ember.Route.transitionTo('withDate')

        withDate: Ember.Route.extend
          route: '/:date'
          connectOutlets: (router, params) ->
            #jumpTo(params)

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
          jumpTo(type: 'contact', id: contact.get('id'))

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
          jumpTo(type: 'user', id: user.get('id'))

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
          jumpTo(calendar: true)

      showDate: Ember.Route.transitionTo('withDate')

      withDate: Ember.Route.extend
        route: '/:date'
        connectOutlets: (router, params) ->
          params.calendar = true
          jumpTo(params)
