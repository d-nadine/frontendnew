Radium.InlineCommentsView = Ember.View.extend
  commentsBinding: 'controller.comments'
  classNames: ['inline-comments']
  templateName: 'radium/inline_comments'
  isErrorBinding: 'controller.isError'
  commentBinding: 'controller.newComment'
  commentTextArea: Ember.TextArea.extend(Ember.TargetActionSupport,
    placeholder: "Add a comment"
    valueBinding: 'parentView.comment'
    classNameBindings: ['parentView.controller.isError:error']
    classNames: ['new-comment']
    action: 'addComment'
    target: 'parentView.controller'

    didInsertElement: ->
      self = this
      @_super()
      @$().focus().autosize().css('resize','none')

    willDestroyElement: ->
      $('html').off('click.autoresize')

    click: (event) ->
      event.stopPropagation()

    keyPress: (event) ->
      if event.keyCode == 13 && !event.ctrlKey
        event.preventDefault()
        if @get('value') != ''
          @triggerAction()
  )
