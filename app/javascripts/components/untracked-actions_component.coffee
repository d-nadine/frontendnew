Radium.UntrackedActionsComponent = Ember.Component.extend
  actions:
    makePublic: (contact) ->
      @get('containingController').send "switchShared", contact

      false

    destroyContact: (contact) ->
      @get('containingController').send "destroyContact", contact

      false

  containingController: Ember.computed.oneWay 'targetObject.table.targetObject'
