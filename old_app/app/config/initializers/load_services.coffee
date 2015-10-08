Ember.Application.initializer
  name: 'load-services'
  after: 'store'
  before: 'registerComponentLookup'
  initialize: (container, application) ->
    eventBus = Radium.EventBus.create()

    application.register('event-bus:current', eventBus, instantiate: false)

    application.inject('component', 'EventBus', 'event-bus:current')
    application.inject('controller', 'EventBus', 'event-bus:current')
    application.inject('route', 'EventBus', 'event-bus:current')

    profileService = Radium.ProfileService.create()

    application.register('profile-service:current', profileService, instantiate: false)

    application.inject('component', 'ProfileService', 'profile-service:current')
    application.inject('controller', 'ProfileService', 'profile-service:current')

    uploader = Ember.Uploader.create()

    application.register('uploader:current', uploader, instantiate: false)

    application.inject('component', 'uploader', 'uploader:current')
    application.inject('controller', 'uploader', 'uploader:current')
    application.inject('view', 'uploader', 'uploader:current')

    # UPGRADE: I think we need to do away with flash messages into an outlet
    # but we can abstract that into an object for now
    flashMessenger = Ember.Object.create
      success: ->
        @sendFlash ["flashSuccess"].concat(Array.prototype.slice.call(arguments))

      error: ->
        @sendFlash ["flashError"].concat(Array.prototype.slice.call(arguments))

      sendFlash: (args) ->
        route = container.lookup('route:application')
        route.send.apply route, args

    application.register('flash:messenger', flashMessenger, instantiate: false)

    application.inject('component', 'flashMessenger', 'flash:messenger')
    application.inject('controller', 'flashMessenger', 'flash:messenger')

    templatesService = Radium.TemplatesService.create()

    application.register('templates:service', templatesService, instantiate: false)
    application.inject('controller', 'templatesService', 'templates:service')
    application.inject('component', 'templatesService', 'templates:service')
    application.inject('route', 'templatesService', 'templates:service')

    listsService = Radium.ListsService.create()

    application.register('lists:service', listsService, instantiate: false)
    application.inject('controller', 'listsService', 'lists:service')
    application.inject('component', 'listsService', 'lists:service')
    application.inject('route', 'listsService', 'lists:service')
