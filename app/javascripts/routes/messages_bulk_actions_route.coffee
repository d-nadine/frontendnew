Radium.MessagesBulkActionsRoute = Radium.Route.extend
  actions:
    checkMessageItem: ->
      @controllerFor('messagesSidebar').send 'checkMessageItem'
      false

    cancel: ->
      @deactivate()
      @controllerFor('messagesSidebar').send 'checkMessageItem'

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
        @send 'notificationDelete', item

        item.deleteRecord()
        item.one 'didDelete', (record) =>
          if record.get('id') == lastRecord.get('id')
            @send 'flashSuccess', 'Emails deleted'
            Ember.run.next =>
              @transitionTo 'index', controller.get('folder')

      @get('store').commit()

      @send 'closeModal'

      @controllerFor('messagesSidebar').send 'reset'

  beforeModel: (controller) ->
    checkedContent = @controllerFor('messages').get('checkedContent')

    unless checkedContent.get('length')
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

      return

  deactivate: ->
    @controllerFor('messages').forEach (item) =>
      item.set 'isChecked', false
