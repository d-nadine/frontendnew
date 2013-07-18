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

      @get('store').commit()

      deal.one 'didDelete', =>
        @render 'nothing',
          into: 'application'
          outlet: 'modal'

        @render 'deal/deleted',
          into: 'application'

      deal.one 'becameInvalid', =>
        debugger

      deal.one 'becameError', =>
        debugger

    showChecklist: (deal) ->
      @controllerFor('dealChecklist').set('model', deal)
      @render 'deal/checklist',
        into: 'application'
        outlet: 'modal'

    confirmStatusChange: ->
      commit = @get('statusChangeCommit')
      controller = @get('statusChangeController')
      commit.call controller
      @send 'close'

    showStatusChangeConfirm: (controller, commit) ->
      # FIXME: hacky way of holding the commit method for later
      @set 'statusChangeController', controller
      @set 'statusChangeCommit', commit
      statusChangeController = @controllerFor('dealConfirmStatusChange')
      statusChangeController.set('model', controller.get('form'))
      statusChangeController.set 'isSubmitted', false
      @render 'deal/confirm_status_change',
        into: 'application'
        outlet: 'modal'

  activate: ->
    # FIXME: use a mixin when we upgrade to rc6
    @_super.apply this, arguments
    return if @events.hasOwnProperty 'saveChecklist'
    Ember.merge @events, Radium.ChecklistEvents

  renderTemplate: ->
    if @modelFor('deal').get('isDestroyed')
      @render 'deal/deleted',
        into: 'application'
    else
      @render()
      @render 'deal/sidebar',
        into: 'deal'
        outlet: 'sidebar'
