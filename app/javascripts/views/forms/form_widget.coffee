require 'radium/controllers/todo_form_controller'

Radium.FormWidgetView = Em.View.extend
  templateName: 'radium/forms/form_widget'
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
    @_super.apply this, arguments
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  TasksContainer: Em.ContainerView.extend()

  taskAction: (e) ->
    action = "#{e.context.get('action')}Action"
    args = [].slice.apply(arguments)

    @get(action).apply(this, args)

  toggleForm: (event) ->
    @get('buttons').forEach (btn) -> btn.set('closed', true) unless btn == event.context

    tasksContainer = @get('tasksContainer')

    button = event.context
    button.toggleProperty('closed')

    if button.get('closed')
      tasksContainer.set('currentView', null)

      return

    action = button.get('action')

    form = @get("#{action}View").create()

    if @get("#{action}Controller")
      controller = @get("#{action}Controller").create()

      Ember.keys(@).forEach (key) =>
        re = /\b[A-Za-z]*Binding\b/
        if key.match(re)
          prop = key.replace('Binding', "")
          controller.set(prop, @get(prop)) if @get(prop)

      form.set('controller', controller)

    form.one('onClose', this, ( (args) ->
      @get('buttons').forEach (btn) -> btn.set('closed', true)
      @get('tasksContainer').set('currentView', null)
    ))

    tasksContainer.set 'currentView', form

  todoView: ( ->
    Radium.TodoFormView.extend Radium.Slider,
      close: ->
        @trigger 'onClose'
  ).property()

  callView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

  meetingView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

  todoController: (->
    Radium.TodoFormController.extend
      kindBinding: 'parentView.parentView.kind'
  ).property()
