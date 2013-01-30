require 'radium/mixins/controllers/form_widget_mixin'

Radium.FormsFormWidgetController = Em.Controller.extend Radium.FormWidgetMixin,
  buttons: [
    Ember.Object.create
     template: "forms/todo_form"
     label: "Todo"
    Ember.Object.create
     template: "unimplemented"
     label: "Meeting"
    Ember.Object.create
     template: "unimplemented"
     label: "Call"
  ]
