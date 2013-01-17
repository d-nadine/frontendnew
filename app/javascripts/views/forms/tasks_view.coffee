require 'radium/controllers/todo_form_controller'

Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'
  displayConfirmation: Ember.K
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
      tasksContainer = @get('tasksContainer')

      if tasksContainer.get('currentView')
        tasksContainer.set('currentView', null)

      return

    action = button.get('action').capitalize()

    getView = "get#{action}View"

    form = if @get(getView) then @get(getView).call(this) else Radium.Core.typeFromString("#{action}FormView").create()

    getController = "get#{action}Controller"

    controller = @get(getController).call(this, form) if @get(getController)

    if !controller && Radium.Core.typeFromString("#{action}FormController")
      controller = Radium.Core.typeFromString("#{action}FormController").create()

    form.set('controller', controller) if controller

    tasksContainer.set 'currentView', form

  getCallController: (form) ->
    controller = @getTodoController(form)
    controller.set('kind', 'call')
    controller

  getMeetingView: ->
    Radium.MeetingFormView.create
      close: ->
        @get('parentView').set('currentView', null)

  getCallView: (button) ->
    @getTodoView(button)

  getTodoView: (button) ->
    Radium.TodoFormView.create Radium.Slider,
      close: ->
        @get('parentView.parentView').closeForm()

  getTodoController: (form) ->
    submitForm =  @get('confirmTask')
    view = this

    Radium.TodoFormController.create
      kind: 'email'
      submit: ->
        @_super.apply this, arguments
        submitForm.call(view, 'todo created!')

  closeForm: (confirmation) ->
    @get('tasksContainer').set('currentView', null)
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  confirmTask: (text) ->
    @displayConfirmation(text)
