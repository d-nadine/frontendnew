require 'radium/controllers/todo_form_controller'

Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'
  displayConfirmation: Ember.K
  todoController: Radium.TodoFormController.extend()

  TasksContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    @showTodoForm('email', 'todo created')

  toggleFollowCall: (e) ->
    @showTodoForm('call', 'follow up call created')

  toggleMeetingForm: (e) ->
    tasksContainer = @get('tasksContainer')

    if tasksContainer.get('currentView')
      tasksContainer.set('currentView', null)

    form = Radium.MeetingFormView.create
      close: ->
        @get('parentView').set('currentView', null)

    form.set 'controller', Radium.MeetingFormController.create()

    tasksContainer.set 'currentView', form

  closeForm: (confirmation) ->
    @get('tasksContainer').set('currentView', null)

  confirmTask: (text) ->
    @displayConfirmation(text)

  showTodoForm: (kind, notification) ->
    tasksContainer = @get('tasksContainer')

    if tasksContainer.get('currentView')
      tasksContainer.set('currentView', null)

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
