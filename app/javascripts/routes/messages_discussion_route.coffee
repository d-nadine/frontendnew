Radium.MessagesDiscussionRoute = Radium.Route.extend
  setupController: (controller, model) ->
    @controllerFor('messages').set 'selectedContent', model
    @_super.apply this, arguments
