Radium.ExternalcontactsRoute = Radium.Route.extend
  model: ->
    user = @controllerFor('currentUser').get('model')
    Radium.ExternalContact.find user_id: user.get('id'), page: 1
