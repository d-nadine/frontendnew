require 'radium/controllers/todo_form_controller'

Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'
  displayConfirmation: Ember.K
  todoController: Radium.TodoFormController.extend()
  buttons: [
    Ember.Object.create
     action: "todo"
     label: "Todo"
     closed: true
    Ember.Object.create
     action: "meeting"
     label: "Meeting"
     closed: true
    Ember.Object.create
     action: "call"
     label: "Call"
     closed: true
  ]

  TasksContainer: Em.ContainerView.extend()

  toggleForm: (event) ->
    @get('buttons').forEach (btn) -> btn.set('closed', true) unless btn == event.context

    button = event.context
    button.toggleProperty('closed')

    if button.get('closed')
      tasksContainer = @get('tasksContainer')

      if tasksContainer.get('currentView')
        tasksContainer.set('currentView', null)

      return

    buttonAction = button.get('action')
    action = "toggle#{buttonAction.charAt(0).toUpperCase()}#{buttonAction.slice(1)}Form"

    args = [].slice.apply(arguments)

    @get(action).apply(this, args)

  toggleTodoForm: (e) ->
    @showTodoForm('email', 'todo created')

  toggleCallForm: (e) ->
    @showTodoForm('call', 'follow up call created')

  toggleMeetingForm: (e) ->
    tasksContainer = @get('tasksContainer')

    form = Radium.MeetingFormView.create
      close: ->
        @get('parentView.parentView').closeForm()

    form.set 'controller', Radium.MeetingFormController.create()

    tasksContainer.set 'currentView', form

  closeForm: (confirmation) ->
    @get('tasksContainer').set('currentView', null)
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  confirmTask: (text) ->
    @displayConfirmation(text)

  showTodoForm: (kind, notification) ->
    tasksContainer = @get('tasksContainer')

    submitForm =  @get('confirmTask')
    view = this

    todoFormView = Radium.TodoFormView.create Radium.Slider,
      close: ->
        @get('parentView.parentView').closeForm()
      controller: view.todoController.create
        kind: kind
        submit: ->
          @_super.apply this, arguments
          submitForm.call(view, 'todo created!')

    tasksContainer.set('currentView', todoFormView)
