Ember.Router.reopen
  history: []

  didTransition: ->
    handler = arguments[0][arguments[0].length - 1]

    entry = if handler.isDynamic
              [handler.name, handler.context]
            else
              [handler.name]

    @get('history').push entry

    @_super.apply this, arguments
