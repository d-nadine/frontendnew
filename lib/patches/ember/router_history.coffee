Ember.Router.reopen
  history: []

  didTransition: ->
    handler = arguments[0].pop()
    entry = [handler.name, handler.context]
    @get('history').push entry

    @_super.apply this, arguments

Ember.Route.reopen
  transitionTo: ->
    @get('router.history').push arguments
    @_super.apply this, arguments
