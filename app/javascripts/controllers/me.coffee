Radium.MeController = Ember.Object.extend
  fetch: ->
    # TODO: do I have to do anything more than checking a cookie?
    event = if Radium.get('_api')
      'switchToAuthenticated'
    else
      'switchToUnauthenticated'

    Radium.get('router').send event
