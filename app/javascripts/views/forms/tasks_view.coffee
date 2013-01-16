Radium.TasksView = Em.View.extend
  templateName: 'radium/forms/tasks'

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
        unless $(event.target).hasClass('close-form')
          @get('parentView.parentView').displayConfirmation('meeting created')
        else
          @get('parentView').set('currentView', null)

    form.set 'controller', Radium.MeetingFormController.create()

    tasksContainer.set 'currentView', form

  closeForm: ->
    @get('tasksContainer').set('currentView', null)

  showTodoForm: (kind, notification) ->
    tasksContainer = @get('tasksContainer')

    if tasksContainer.get('currentView')
      tasksContainer.set('currentView', null)

    todoFormView = Radium.TodoFormView.create
      close: ->
        @get('parentView.parentView').closeForm()
      controller: Radium.TodoFormController.create
        kind: kind

    tasksContainer.set('currentView', todoFormView)
