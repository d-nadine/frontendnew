Radium.UntrackedActionsComponent = Ember.Component.extend
  actions:
    track: (contact) ->
      @get('containingController').send "track", contact

    destroyContact: (contact) ->
      @get('containingController').send "destroyContact", contact

  containingController: Ember.computed.oneWay 'targetObject.table.targetObject'
