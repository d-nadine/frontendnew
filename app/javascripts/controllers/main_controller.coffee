Radium.MainController = Ember.Controller.extend
  connectOutlet: ->
    view = @_super.apply this, arguments
    if view && view.get('controller.isFeedController')
      # FIXME: state should be on the router. Not on the global
      Radium.set 'currentFeedController', view.get('controller')

