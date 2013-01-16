Radium.BulkEmailActionView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'
  FormContainer: Em.ContainerView.extend()
  didInsertElement: ->
    @$(".block-connected").hide()
  toggleTodoForm: (e) ->
    formContainer = @get('formContainer')

    @$(".block-connected").toggle()

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
