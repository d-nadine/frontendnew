Radium.ContactRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      @render 'contact/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      contact = @modelFor 'contact'

      contact.deleteRecord()

      @render 'nothing',
        into: 'application'
        outlet: 'modal'

      @render 'contact/deleted',
        into: 'application'

  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'
