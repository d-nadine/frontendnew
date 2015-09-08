Radium.ListRoute = Ember.Route.extend
  beforeModel: (transition) ->
    controller = @controllerFor('list')

    listId = transition.params['list'].list_id

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.Deal.find(list: listId).then((results) ->
        controller.set 'deals', results
        resolve results
      ).catch (error) ->
        Ember.Logger.error(error)
        reject error
