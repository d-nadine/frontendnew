Radium.PipelinePipelineWidgetController = Radium.FormsBulkFormWidgetController.extend
  buttons: [
    Ember.Object.create
      template: "unimplemented"
      label: "Assign"
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
      label: "Email"
    Ember.Object.create
      template: "unimplemented"
      label: "Change Status"
    Ember.Object.create
      action: "deleteAll"
      label: "Remove"
      alwaysOpen: true
      classes: 'btn btn-danger'
      icons: 'icon-trash icon-large icon-white'
  ]


