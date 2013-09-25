require 'mixins/routes/deal_status_change_mixin'
require 'routes/mixins/checklist_mixins'

Radium.DealRoute = Radium.Route.extend Radium.ChecklistEvents, Radium.DealStatusChangeMixin,
  actions:
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

      @get('store').commit()

      deal.one 'didDelete', =>
        @render 'nothing',
          into: 'application'
          outlet: 'modal'

        @render 'deal/deleted',
          into: 'application'

      deal.one 'becameInvalid', =>
        console.error 'deal becameInvalid'

      deal.one 'becameError', =>
        console.error 'deal becameError'

    showChecklist: (deal) ->
      @controllerFor('dealChecklist').set('model', deal)
      @render 'deal/checklist',
        into: 'application'
        outlet: 'modal'

  renderTemplate: ->
    if @modelFor('deal').get('isDestroyed')
      @render 'deal/deleted',
        into: 'application'
    else
      @render()
      @render 'deal/sidebar',
        into: 'deal'
        outlet: 'sidebar'
