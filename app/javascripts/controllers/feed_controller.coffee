Radium.FeedController = Em.ArrayController.extend
  init: ->
    @set('content', Ember.A())
    @_super.apply(this, arguments)
