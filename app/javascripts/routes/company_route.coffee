Radium.CompanyRoute = Radium.Route.extend
  renderTemplate: ->
    @render()
    @render 'company/sidebar',
      into: 'company'
      outlet: 'sidebar'
