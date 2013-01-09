Radium.InboxView = Em.View.extend
  templateName: 'radium/inbox/inbox'

  FormContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    e.stopPropagation()

    formContainer = @get('formContainer')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)
      return

    todoFormView = Radium.TodoFormView.create(Radium.Slider,
      selectionBinding: 'controller.selectedMail',
      kind: 'email'
      createTodo: @get('controller').createTodo
    )

    formContainer.set 'currentView', todoFormView

  arrow: Em.View.extend
    classNames: 'arrow'
    isVisible: ( ->
      @get('parentView.controller.length') > 0
    ).property('parentView.controller.length')

