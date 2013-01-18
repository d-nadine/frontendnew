require 'radium/controllers/todo_form_controller'

Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'
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
    console.log @get('reference').constructor
    @get('buttons').forEach (btn) -> btn.set('closed', true) unless btn == event.context

    tasksContainer = @get('tasksContainer')

    button = event.context
    button.toggleProperty('closed')

    if button.get('closed')
      tasksContainer.set('currentView', null)

      return

    action = button.get('action')

    form = @get("#{action}View").create()

    controller = @get("#{action}Controller").create() if @get("#{action}Controller")

    form.set('controller', controller) if controller

    tasksContainer.set 'currentView', form

  todoView: ( ->
    Radium.TodoFormView.extend Radium.Slider,
      close: ->
        @get('parentView.parentView').closeForm()
  ).property()

  callView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

  meetingView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

  todoController: (->
    Radium.TodoFormController.extend
      kind: 'email'
      submit: ->
        @_super.apply this, arguments
        Radium.Utils.notify('Todo created!')
  ).property()

  closeForm: (confirmation) ->
    @get('tasksContainer').set('currentView', null)
