Ember.Application.initializer
  name: 'load-services'
  initialize: (container, application) ->
    profileService = Radium.ProfileService.create()

    application.register('profile-service:current', profileService, instantiate: false)

    application.inject('component', 'ProfileService', 'profile-service:current')
    application.inject('controller', 'ProfileService', 'profile-service:current')
