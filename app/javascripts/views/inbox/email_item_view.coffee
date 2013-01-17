Radium.EmailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  templateName: 'radium/inbox/email_item'
  classNames: 'email'.w()
  showActions: false

  tasksView: Radium.TasksView.extend
    displayConfirmation: (text) ->
      @get('parentView').displayConfirmation(text)

  showActionSection: ->
    @toggleProperty('showActions')

  displayConfirmation: (text) ->
    ele = $('.email-alert-area', @$())
    Radium.Utils.notify text, ele: ele

  CommentsContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
