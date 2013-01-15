DS.Model.reopen
  commit: ->
    @store.commit()

Ember.Application.reopen
  registerInitializer: (initializer) ->
    @constructor.registerInitializer initializer

  ready: ->
    @get('constructor.initializers').forEach (initializer) ->
      initializer.apply @

Ember.Application.reopenClass
  initializers: Ember.A()
  registerInitializer: (initializer) ->
    initializers = Ember.get(@, 'initializers')
    initializers.push initializer

