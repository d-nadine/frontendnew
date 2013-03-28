Radium.MessagesDiscussionRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @controllerFor('messages').set 'selectedContent', model
