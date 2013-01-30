require 'radium/mixins/controllers/form_widget_mixin'

Radium.FormsBulkFormWidgetController = Ember.ArrayController.extend Radium.FormWidgetMixin,
  buttons: [
    Ember.Object.create
      action: "deleteAll"
      label: "Delete"
      alwaysOpen: true
      classes: 'btn btn-danger'
      icons: 'icon-trash icon-large icon-white'
    Ember.Object.create
      template: "forms/bulk_todo_form"
      label: "Todo"
    Ember.Object.create
      template: "unimplemented"
      label: "Meeting"
    Ember.Object.create
      template: "unimplemented"
      label: "Call"
    Ember.Object.create
      template: "unimplemented"
      label: "Call"
  ]

  executeAction: (button) ->
    @send button.action

  # FIXME: figure how to update the UI
  deleteAll: ->
    @forEach (record) =>
      record.deleteRecord()
      record.get('store').commit()
