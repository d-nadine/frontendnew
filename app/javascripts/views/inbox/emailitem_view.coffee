Radium.EmailItemView = Em.View.extend
  templateName: 'radium/inbox/email'
  classNames: 'email'.w()
  didInsertElement: ->
    active = $('ul.messages li.active')
    return if active.length == 0

    setTimeout(( ->
      $('div.arrow').css(top: active.offset().top - 35))
      , 200)

  showActions: false
  showActionSection: ->
    @toggleProperty('showActions')

  ActionContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    formContainer = @get('actionContainer')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)

    todoFormView = Radium.TodoFormView.create(Radium.Slider,
      selectionBinding: 'parentView.parentView.content',
      kind: 'email'
      createTodo: Radium.get('router.inboxController').createTodo
      displayNotification: ->
        ele = $('.email-alert-area', @get('parentView.parentView').$())
        Radium.Utils.notify 'todos created', ele: ele
    )

    formContainer.set 'currentView', todoFormView
  FormContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
