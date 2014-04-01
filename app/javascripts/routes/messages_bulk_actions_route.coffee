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

      items = Ember.A(controller.get('checkedContent'))

      lastRecord = items.get('lastObject')

      controller.get('checkedContent').setEach 'isChecked', false

      # for item in items.slice(0).reverse()
        # items.forEach (item) ->
        # o = controller.find (rec) -> rec.get('id') == item.get('id')
        # controller.removeObject(o) if o

      for i in [items.length - 1..0] by -1
        item = items[i]
        # controller.removeObject item
        @send 'notificationDelete', item

        item.deleteRecord()

        # Ember.run.once(this, this.batchDeletes)
        item.one 'didDelete', (record) =>
          if record.get('id') == lastRecord.get('id')
            @send 'flashSuccess', 'Emails deleted'
            # FIXME: This causes filterBy to break, 
            # I've reported this issue https://github.com/emberjs/ember.js/issues/4620
            # @controllerFor('messagesSidebar').send('checkMessageItem')

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
    @controllerFor('messages').forEach (item) =>
      item.set 'isChecked', false
