Radium.FormsBulkFormWidgetController = Ember.ArrayController.extend Radium.FormWidgetMixin,
  buttons: [
    Ember.Object.create
      action: "cancelAll"
      title: "Cancel"
      alwaysOpen: true
      classes: 'btn pull-right'
    Ember.Object.create
      action: "deleteAll"
      title: "Delete"
      alwaysOpen: true
      classes: 'btn btn-danger'
      icons: 'icon-trash icon-large icon-white'
    Ember.Object.create
      template: "forms/bulk_todo_form"
      title: "Todo"
      name: 'todo'
    Ember.Object.create
      template: "unimplemented"
      title: "Meeting"
      name: 'meeting'
    Ember.Object.create
      template: "unimplemented"
      title: "Call"
      name: 'call'
  ]

  executeAction: (button) ->
    @send button.action

  # FIXME: figure how to update the UI
  deleteAll: ->
    @forEach (record) =>
      record.deleteRecord()
      record.get('store').commit()
