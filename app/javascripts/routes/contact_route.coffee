Radium.ContactRoute = Radium.Route.extend
  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'
