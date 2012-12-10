Radium.MeController = Ember.Object.extend
  fetch: ->
    # TODO: do I have to do anything more than checking a cookie?
    event = if Radium.get('_api')
      'switchToAuthenticated'
    else
      'switchToUnauthenticated'

    Radium.get('router').send event
  # TODO: I hardcoded it for now, but we will have to somehow fetch current user's id
  userId: 1
  user: (->
    @get('store').find(Radium.User, @get('userId'))
  ).property()
