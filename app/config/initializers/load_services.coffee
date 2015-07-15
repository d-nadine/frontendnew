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

    uploader = Ember.Uploader.create()

    application.register('uploader:current', uploader, instantiate: false)

    application.inject('component', 'uploader', 'uploader:current')
    application.inject('controller', 'uploader', 'uploader:current')
    application.inject('view', 'uploader', 'uploader:current')
