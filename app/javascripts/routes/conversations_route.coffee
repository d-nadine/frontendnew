Radium.ConversationsRoute = Radium.Route.extend
  beforeModel: (transition) ->
    type = transition.params.conversations.type
    @controllerFor("conversations").set('conversationType', type)
    type

  model: (params) ->
    Radium.Email.find(name: params.type)

  setupController: (controller, model) ->
   @_super.apply this, arguments
   controller.set 'model', model
   controller.send 'updateTotals'