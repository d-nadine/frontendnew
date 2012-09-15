Radium.MainController = Ember.Controller.extend
  connectOutlet: ->
    view = @_super.apply this, arguments
    if view && view.get('controller.isFeedController')
      Radium.set 'currentFeedController', view.get('controller')

