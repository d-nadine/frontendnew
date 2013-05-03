Radium.TagRoute = Radium.Route.extend
  renderTemplate: ->
    @render()
    @render 'tag/sidebar',
      into: 'tag'
      outlet: 'sidebar'

