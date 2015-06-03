Ember.Application.initializer
  name: 'load-services'
  after: 'store'
  before: 'registerComponentLookup'
  initialize: (container, application) ->
    eventBus = Radium.EventBus.create()

    application.register('event-bus:current', eventBus, instantiate: false)

    application.inject('component', 'EventBus', 'event-bus:current')
    application.inject('controller', 'EventBus', 'event-bus:current')

    profileService = Radium.ProfileService.create()

    application.register('profile-service:current', profileService, instantiate: false)

    application.inject('component', 'ProfileService', 'profile-service:current')
    application.inject('controller', 'ProfileService', 'profile-service:current')

    initImportPoller = Radium.InitialImportPoller.create
      currentUser: container.lookup('controller:currentUser')

    application.register('importpoller-service:current', initImportPoller, instantiate: false)
    application.inject('route', 'initialImportPoller', 'importpoller-service:current')

    store = container.lookup('store:main')

    uploader = Ember.Uploader.create()

    application.register('uploader:current', uploader, instantiate: false)

    application.inject('component', 'uploader', 'uploader:current')
    application.inject('controller', 'uploader', 'uploader:current')
    application.inject('view', 'uploader', 'uploader:current')
