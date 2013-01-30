Radium.FormsFormWidgetController = Em.Controller.extend
  buttons: [
    Ember.Object.create
     template: "forms.todo_form"
     label: "Todo"
    Ember.Object.create
     action: "meeting"
     label: "Meeting"
    Ember.Object.create
     action: "call"
     label: "Call"
  ]

  activeForm: null

  init: ->
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  toggleForm: (button)  ->
    if @get('activeForm') == button.template 
      @set 'activeForm', null
    else
      @set 'activeForm', button.template

