Radium.UsersTotalsComponent = Ember.Component.extend
  actions:
    showUserRecords: (user, type) ->
      @sendAction "action", user, type

      false
