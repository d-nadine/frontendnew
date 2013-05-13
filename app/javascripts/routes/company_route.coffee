Radium.CompanyRoute = Radium.Route.extend
  events:

    confirmDeletion: ->
      @render 'company/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      company = @modelFor 'company'

      company.deleteRecord()

      @render 'nothing',
        into: 'application'
        outlet: 'modal'

      @render 'company/deleted',
        into: 'application'

  renderTemplate: ->
    @render()
    @render 'company/sidebar',
      into: 'company'
      outlet: 'sidebar'
