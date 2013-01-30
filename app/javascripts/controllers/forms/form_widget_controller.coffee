Radium.FormsFormWidgetController = Em.Controller.extend
  buttons: [
    Ember.Object.create
     action: "todo"
     label: "Todo"
    Ember.Object.create
     action: "meeting"
     label: "Meeting"
    Ember.Object.create
     action: "call"
     label: "Call"
  ]
  init: ->
    @get('buttons').forEach (btn) -> btn.set('closed', true)
