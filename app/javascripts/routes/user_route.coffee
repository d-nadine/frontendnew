Radium.UserRoute = Radium.Route.extend
  renderTemplate: ->
    @render()
    @render 'user/sidebar',
      into: 'user'
      outlet: 'sidebar'

