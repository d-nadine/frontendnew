Radium.MessagesBulkActionsRoute = Radium.Route.extend
  actions:
    cancel: ->
      @deactivate()
      @send 'back'

    confirmDeletion: ->
      @render 'messages/bulk_deletion_confirmation',
        into: 'application',
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application',
        outlet: 'modal'

    delete: ->
      controller = @controllerFor('messages')

      items = controller.get('checkedContent').toArray()

      controller.clear()

      transaction = @get('store').transaction() 

      items.toArray().forEach (item) -> 
        transaction.add item
        item.deleteRecord()

      controller.load()
      @send 'closeModal'
      @transitionTo 'messages'


  setupController: (controller) ->
    checkedContent = @controllerFor('messages').get('checkedContent')
    controller.set 'model', checkedContent

  deactivate: ->
    @controllerFor('messages').forEach (item) =>
      item.set 'isChecked', false

    # FIXME: why is this reuqired?
    @render 'nothing', into: 'messages'
