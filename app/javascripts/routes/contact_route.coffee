Radium.ContactRoute = Radium.Route.extend
  events:
    confirmDeletion: ->
      @render 'deal/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'


  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'
