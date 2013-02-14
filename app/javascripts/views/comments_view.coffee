Radium.CommentsView = Ember.View.extend
  commentTextArea: Ember.TextArea.extend(Ember.TargetActionSupport,
    placeholder: 'Add a comment'
    valueBinding: 'controller.comment.text'
    classNames: ['new-comment']
    target: 'controller'
    action: 'submit'

    didInsertElement: ->
      @_super()
      @$().autosize().css('resize','none')

    willDestroyElement: ->
      @$().off('autosize')

    click: (event) ->
      event.stopPropagation()

    insertNewline: -> 
      @triggerAction()
  )
