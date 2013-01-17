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
      close: ->
        @get('parentView.parentView').toggleTodoForm()
      controller: Radium.TodoFormController.create
        kind: 'email'
        submit: ->
          debugger
          return unless @get('selection')

          @get('selection').forEach (email) =>
            todo = Radium.Todo.createRecord
              kind: @get('kind')
              finishBy: @get('finishBy')
              user: Radium.get('router.currentUser')
              description: @get('description')

            todo.set('reference', email)

          Radium.get('router.store').commit()

          Radium.Utils.notify('Todos created')
    )

    todoFormView.set('controller.selection', @get('controller.selectedMail'))

    formContainer.set 'currentView', todoFormView
