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
  FormContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
