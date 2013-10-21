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

      lastRecord = items[items.length-1]

      items.toArray().forEach (item) =>
        notifications =  Radium.Notification.all().filter (notification) => notification.get('reference') == item
        notifications.forEach (notification) =>
          notification.deleteRecord()

        item.deleteRecord()
        item.one 'didDelete', (record) =>
          if record.get('id') == lastRecord.get('id')
            @send 'flashSuccess', 'Emails deleted'
            @transitionTo 'messages', controller.get('folder')

      @get('store').commit()

      @send 'closeModal'

      @controllerFor('messagesSidebar').send 'reset'

  setupController: (controller) ->
    checkedContent = @controllerFor('messages').get('checkedContent')
    controller.set 'model', checkedContent

  deactivate: ->
    @controllerFor('messages').forEach (item) =>
      item.set 'isChecked', false

    # FIXME: why is this reuqired?
    @render 'nothing', into: 'messages'
