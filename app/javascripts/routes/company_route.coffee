Radium.CompanyRoute = Radium.Route.extend
  events:
    addContact: (company) ->
      debugger
      controller = @controllerFor('leads.new')
      controller.get('model').reset()
      controller.set 'user', @controllerFor('currentUser').get('model')
      controller.set('company', company)
      controller.set('status', company.get('status'))
      @transitionTo 'leads.new'

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
