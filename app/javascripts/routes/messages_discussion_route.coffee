Radium.MessagesDiscussionRoute = Radium.Route.extend
  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model
