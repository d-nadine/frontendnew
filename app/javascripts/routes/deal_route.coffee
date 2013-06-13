Radium.DealRoute = Radium.Route.extend
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

    showChecklist: ->
      @render 'deal/checklist',
        into: 'application'
        outlet: 'modal'

    saveChecklist: ->
      @get('store').commit()
      @send 'close'

    cancelChecklistSave: (model)->
      model.get('transaction').rollback()
      @send 'close'

  renderTemplate: ->
    if @modelFor('deal').get('isDestroyed')
      @render 'deal/deleted',
        into: 'application'
    else
      @render()
      @render 'deal/sidebar',
        into: 'deal'
        outlet: 'sidebar'
