Radium.EmailsThreadRoute = Radium.ShowRouteBase.extend
  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model
    controller.set 'model', model.get('replies')
