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

      deal.delete(this).then (result) =>
        @transitionTo 'pipeline.index'

        @send 'flashSuccess', "Deal #{name} has been deleted"

      @send 'closeModal'

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
    ['todo', 'meeting'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)

  deactivate: ->
    @controller.get('model').reset()
