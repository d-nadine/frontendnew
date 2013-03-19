Radium.MessagesBulkActionsRoute = Ember.Route.extend
  events:
    cancel: ->
      @deactivate()
      @send 'back'

  setupController: (controller) ->
    checkedContent = @controllerFor('messages').get('checkedContent')
    controller.set 'model', checkedContent

  deactivate: ->
    @controllerFor('messages').forEach (item) =>
      item.set 'isChecked', false
