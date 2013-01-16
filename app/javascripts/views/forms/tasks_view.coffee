Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'
  # init: ->
  #   @set('controller', Radium.TasksController.create())

  TasksContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    @showTodoForm('email', 'todo created')

  showTodoForm: (kind, notification) ->
    tasksContainer = @get('tasksContainer')

    if tasksContainer.get('currentView')
      tasksContainer.set('currentView', null)

    todoFormView = Radium.TodoFormView.create()

    tasksContainer.set('currentView', todoFormView)
