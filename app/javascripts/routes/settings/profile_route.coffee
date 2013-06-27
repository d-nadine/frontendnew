Radium.SettingsProfileRoute = Radium.Route.extend
  model: ->
    Ember.run.next(=>
      currentUser = @get("controller.currentUser")
      transaction = @store.transaction()
      transaction.add(currentUser)
      currentUser
    )

  events:
    save: (user) ->
      user.get('transaction').commit()

    cancel: (user) ->
      user.get('transaction').rollback()
