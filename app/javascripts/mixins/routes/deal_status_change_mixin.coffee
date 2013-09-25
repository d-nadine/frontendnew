Radium.DealStatusChangeMixin = Ember.Mixin.create
  actions:
    confirmStatusChange: ->
      commit = @get('statusChangeCommit')
      controller = @get('statusChangeController')
      if lostBecause = controller.get('lostBecause')
        controller.get('model').set('lostBecause', lostBecause)

      commit.call controller
      @send 'close'

    showStatusChangeConfirm: (controller, commit) ->
      # FIXME: hacky way of holding the commit method for later
      @set 'statusChangeController', controller
      @set 'statusChangeCommit', commit
      statusChangeController = @controllerFor('dealConfirmStatusChange')

      model = if controller.get('form')
                controller.get('form')
              else
                controller

      statusChangeController.set('model', model)
      statusChangeController.set 'isSubmitted', false

      @render 'deal/confirm_status_change',
        into: 'application'
        outlet: 'modal'
