Radium.CompanyRoute = Radium.Route.extend
  actions:
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

      name = company.get('name')

      @get('store').commit()

      @send 'flashSuccess', "The company #{name} has been deleted"
      @transitionTo 'addressbook.filter', 'companies'

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
