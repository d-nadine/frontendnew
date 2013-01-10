<<<<<<< HEAD
=======
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
runWhenLoaded = Radium.Utils.runWhenLoaded
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

>>>>>>> start show email history
Radium.Router = Ember.Router.extend
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

    @set('activeFeedController', @get(controllerName))

  showUser: Ember.Route.transitionTo('root.users.user')
  showContacts: Ember.Route.transitionTo('root.contacts.index')
  showContact: Ember.Route.transitionTo('root.contacts.contact')
  showDeal: Ember.Route.transitionTo('root.deal')
  showCampaign: Ember.Route.transitionTo('root.campaigns.campaign')
  showGroup: Ember.Route.transitionTo('root.groups.group')
  showDashboard: Ember.Route.transitionTo('root.dashboard.all')
  showCalendar: Ember.Route.transitionTo('root.calendar.index')
  showInbox : Ember.Route.transitionTo('root.inbox.index')
  showEmail : Ember.Route.transitionTo('root.inbox.email')

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
    showGroup: Ember.Route.transitionTo('root.groups.group')
    showDashboard: Ember.Route.transitionTo('root.dashboard')

    expandFeedItem: (router, event) ->
      router.set 'activeFeedController.expandedItem', event.context
    scrollFeedToDate: (router, event) ->
      router.set 'activeFeedController.currentDate', event.context

    initialState: 'dashboard'

    dashboard: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

        router.connectFeed router.get('currentUser'), 'dashboardFeed'

    groups: Ember.Route.extend
      route: '/groups'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

      group: Ember.Route.extend
        route: '/:group_id'

        connectOutlets: (router, group) ->
          router.connectFeed group, 'groupFeed'

    contacts: Ember.Route.extend
      route: '/contacts'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'contactsSidebar')
        router.get('mainController').connectOutlet('content', 'contacts')

      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('contactsController').set('collection', Radium.Contact.find())

      contact: Ember.Route.extend
        route: '/:contact_id'
        connectOutlets: (router, contact) ->
          router.connectFeed contact, 'contactFeed'

    inbox: Em.Route.extend
      route: '/inbox'
      connectOutlets: (router) ->
        content = Radium.Email.find()
        router.get('applicationController').connectOutlet('sidebar', 'inboxSidebar', content)
        router.get('inboxController').set('content', content)

        sidebarController = router.get('inboxSidebarController')

        router.get('mainController').connectOutlet('content', 'inbox')

        unless sidebarController.get('active')
          runWhenLoaded content, ->
            if content.get('length') > 0
              active = content.get('firstObject')
              sidebarController.setActive(active)
              router.send('showEmail', active)
        else
          router.send('showEmail', sidebarController.get('active'))

      index: Em.Route.extend
        route: '/'

      email: Em.Route.extend
        route: '/:email_id'
        connectOutlets: (router, email) ->
          history = Radium.Email.find(historyFor: email)

          router.get('inboxController').connectOutlet('emailSection', history)
          router.get('emailSectionController').connectOutlet
            controller: router.get('emailSectionController')
            viewClass: Radium.EmailView
          router.get('emailSectionController').connectOutlet
            controller: router.get('emailSectionController')
            viewClass: Radium.ShowMoreEmailsView
            outletName: 'showmore'

    users: Ember.Route.extend
      route: '/users'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('sidebar', 'sidebar')

      user: Ember.Route.extend
        route: '/:user_id'
        connectOutlets: (router, user) ->
          router.connectFeed user, 'userFeed'
