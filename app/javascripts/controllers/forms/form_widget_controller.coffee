Radium.FormsFormWidgetController = Em.Controller.extend
  buttons: [
    Ember.Object.create
     template: "forms.todo_form"
     label: "Todo"
    Ember.Object.create
     template: "unimplemented"
     label: "Meeting"
    Ember.Object.create
     template: "unimplemented"
     label: "Call"
  ]

  activeForm: null

  init: ->
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  toggleForm: (button)  ->
    if @get('activeForm') && @get('activeForm') == button.template
      @set 'activeForm', null
    else
      @set 'activeForm', null
      # FIXME: remove runloop next
      Ember.run.next =>
        @set 'activeForm', button.template

