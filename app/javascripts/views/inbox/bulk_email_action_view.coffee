Radium.BulkEmailActionView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'
  FormContainer: Em.ContainerView.extend()
  toggleTodoForm: (e) ->
    formContainer = @get('formContainer')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)
      return

    todoFormView = Radium.TodoFormView.create(Radium.Slider,
      selectionBinding: 'controller.selectedMail',
      kind: 'email'
      createTodo: @get('controller').createTodo
      displayNotification: ->
        Radium.Utils.notify 'todos created'
    )

    formContainer.set 'currentView', todoFormView
