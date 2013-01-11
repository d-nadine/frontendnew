Radium.EmailItemView = Em.View.extend
  templateName: 'radium/inbox/email'
  classNames: 'email'.w()
  didInsertElement: ->
    active = $('ul.messages li.active')
    return if active.length == 0

    setTimeout(( ->
      $('div.arrow').css(top: active.offset().top - 35))
      , 200)

  showComments: false
  showCommentsSection: ->
    @toggleProperty('showComments')
  FormContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          feedItemBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
