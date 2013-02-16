Radium.DealRoute = Ember.Route.extend
  renderTemplate: ->
    @render()
    @render 'deal/sidebar'
      into: 'deal'
      outlet: 'sidebar'
