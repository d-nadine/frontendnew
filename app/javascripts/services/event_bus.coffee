Radium.EventBus = Ember.Object.extend Ember.Evented,
  publish: ->
    @trigger.apply this, arguments

  subscribe: ->
    @on.apply this, arguments

  unsubscribe: ->
    @off.apply this, arguments
