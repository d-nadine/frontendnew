Radium.MessagesEmailRoute = Radium.Route.extend
  setupController: (controller, model) ->
    @controllerFor('messages').set 'selectedContent', model
