require 'routes/emails/base_show_route'

Radium.EmailsShowRoute = Radium.ShowRouteBase.extend Radium.SaveEmailMixin,
  model: (params) ->
    type = @controllerFor('messages').requestType()

    type.find(params.email_id)

  setupController: (controller, model) ->
    Ember.assert "a model should be sent to EmailsShowRoute", model

    if !model.get('isRead')
      model.set 'isRead', true
      mode.save()

    @controllerFor('messages').set 'selectedContent', model
    controller.set 'model', model
