require 'radium/mixins/controllers/form_widget_mixin'

Radium.FormsFormWidgetController = Em.Controller.extend Radium.FormWidgetMixin,
  buttons: [
    Ember.Object.create
      template: "forms/todo_form"
      title: "Todo"
    Ember.Object.create
      template: "unimplemented"
      title: "Meeting"
    Ember.Object.create
      template: "unimplemented"
      title: "Call"
  ]
