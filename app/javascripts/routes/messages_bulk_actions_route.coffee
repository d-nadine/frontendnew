Radium.MessagesBulkActionsRoute = Radium.Route.extend
  actions:
    checkMessageItem: ->
      @controllerFor('messagesSidebar').send 'checkMessageItem'
      false

    cancel: ->
      Ember.run.once this, 'uncheckItems'
      Ember.run.next =>
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
      Ember.run.once this, 'batchDeletes'

  batchDeletes: ->
    controller = @controllerFor('messages')

    items = Ember.A(controller.get('checkedContent').slice())

    lastRecord = items.get('lastObject')

    for i in [items.length - 1..0] by -1
      item = items[i]
      controller.removeObject item
      @send 'notificationDelete', item

      item.deleteRecord()

      item.one 'didDelete', (record) =>
        if record.get('id') == lastRecord.get('id')
          @send 'flashSuccess', 'Emails deleted'
          @controllerFor('messagesSidebar').send('checkMessageItem')

    @get('store').commit()

    @send 'closeModal'

  beforeModel: (transition) ->
    checkedContent = @controllerFor('messages').get('checkedContent')

    unless checkedContent.get('length')
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

      return

  model: ->
    undefined

  deactivate: ->
    Ember.run.once this, 'uncheckItems'

  uncheckItems: ->
    @controllerFor('messages').setEach 'isChecked', false
