Radium.EmailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  templateName: 'radium/inbox/email_item'
  classNames: 'email'.w()
  showActions: false

  tasksView: Radium.TasksView.extend()

  showActionSection: ->
    @toggleProperty('showActions')

  FormContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
