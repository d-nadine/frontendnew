Radium.CommentsView = Ember.View.extend
  commentTextArea: Ember.TextArea.extend(Ember.TargetActionSupport,
    classNames: ['field-blend-in']
    placeholder: 'Add a comment'
    valueBinding: 'controller.text'
    classNames: ['new-comment']
    target: 'controller'
    action: 'submit'

    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

    click: (event) ->
      event.stopPropagation()

    insertNewline: -> 
      @triggerAction()
  )
