require 'radium/views/inbox/email_table_view'

Radium.BulkEmailActionsView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'

  checkedEmailTableView: Radium.EmailTableView.extend
    contentBinding: 'parentView.controller'

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
          selectedMail = todoFormView.get('parentView.controller.selectedMail')

          return unless selectedMail.get('.length')

          selectedMail.forEach (email) =>
            todo = Radium.Todo.createRecord
              kind: @get('kind')
              finishBy: @get('finishBy')
              user: Radium.get('router.currentUser')
              description: @get('description')

            todo.set('reference', email)

          Radium.get('router.store').commit()

          Radium.Utils.notify('Todos created!')
    )

    formContainer.set 'currentView', todoFormView
