Ember.Router.reopen
  history: []

  didTransition: ->
    handler = arguments[0][arguments[0].length - 1]

    entry = [handler.name, handler.context]
    @get('history').push entry

    @_super.apply this, arguments
