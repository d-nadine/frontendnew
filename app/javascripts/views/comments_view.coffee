require 'lib/radium/text_area'

Radium.CommentsView = Ember.View.extend
  commentTextArea: Radium.TextArea.extend(Ember.TargetActionSupport,
    classNames: ['field-blend-in']
    placeholder: 'Add a comment'
    valueBinding: 'controller.text'
    classNames: ['new-comment']
    target: 'controller'
    action: 'submit'

    click: (event) ->
      event.stopPropagation()

    insertNewline: ->
      @triggerAction()
  )
