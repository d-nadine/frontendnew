Radium.DealRoute = Ember.Route.extend
  events:
    confirmDeletion: ->
      @render 'deal/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      deal = @modelFor 'deal'

      deal.deleteRecord()

      @render 'nothing',
        into: 'application'
        outlet: 'modal'

      @render 'deal/deleted',
        into: 'application'

  renderTemplate: ->
    @render()
    @render 'deal/sidebar'
      into: 'deal'
      outlet: 'sidebar'
