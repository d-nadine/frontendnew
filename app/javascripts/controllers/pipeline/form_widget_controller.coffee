Radium.PipelineFormWidgetController = Radium.FormsBulkFormWidgetController.extend
  buttons: [
    Ember.Object.create
      template: "unimplemented"
      title: "Assign"
    Ember.Object.create
      template: "forms/bulk_todo_form"
      title: "Todo"
    Ember.Object.create
      template: "unimplemented"
      title: "Meeting"
    Ember.Object.create
      template: "unimplemented"
      title: "Call"
    Ember.Object.create
      template: "unimplemented"
      title: "Email"
    Ember.Object.create
      template: "unimplemented"
      title: "Change Status"
    Ember.Object.create
      action: "deleteAll"
      title: "Remove"
      alwaysOpen: true
      classes: 'btn btn-danger'
      icons: 'icon-trash icon-large icon-white'
  ]


