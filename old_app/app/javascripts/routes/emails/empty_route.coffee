Radium.EmailsEmptyRoute = Radium.Route.extend
  model: ->
    @controllerFor('messages').get('folder')
