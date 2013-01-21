Radium.EmailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  templateName: 'radium/inbox/email_item'
  classNames: 'email'.w()
  showActions: false

  FormWidget: Radium.FormWidgetView.extend()

  showActionSection: ->
    @toggleProperty('showActions')

  CommentsContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
