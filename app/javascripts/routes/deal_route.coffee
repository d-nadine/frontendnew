require 'mixins/routes/deal_status_change_mixin'
require 'routes/mixins/checklist_mixins'

Radium.DealRoute = Radium.Route.extend Radium.ChecklistEvents, Radium.DealStatusChangeMixin,
  actions:
    confirmDeletion: ->
      @render 'deal/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @controller.discardBufferedChanges() if @controller.discardBufferedChanges

      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      deal = @modelFor 'deal'

      name = deal.get('name')

      deal.deleteRecord()

      deal.one 'didDelete', =>
        @send 'flashSuccess', "Deal #{name} has been deleted"

      deal.one 'becameInvalid', (result) =>
        result.reset()

      deal.one 'becameError', (result) =>
        result.reset()

      @send 'closeModal'
      @transitionTo 'pipeline.index'

      @get('store').commit()

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

  setupController: (controller, model) ->
    ['todo', 'call', 'meeting'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)   
