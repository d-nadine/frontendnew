Radium.InboxView = Em.View.extend
  init: ->
    @_super.apply this, arguments
    @get('formContainer').create()
  templateName: 'radium/inbox/inbox'
  contentBinding: 'controller.content'

  formContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    e.stopPropagation()

    formContainer = @get('childViews.firstObject')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)
      return

    todoFormView = Radium.TodoFormView.create(Radium.Slider)
    formContainer.set 'currentView', todoFormView

  arrow: Em.View.extend
    classNames: 'arrow'
    isVisible: ( ->
      @get('parentView.controller.length') > 0
    ).property('parentView.controller.length')

