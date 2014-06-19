require 'routes/emails/base_show_route'

Radium.EmailsShowRoute = Radium.ShowRouteBase.extend Radium.SaveEmailMixin,
  setupController: (controller, model) ->
    Ember.assert "a model should be sent to EmailsShowRoute", model
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model
    controller.set 'model', model
