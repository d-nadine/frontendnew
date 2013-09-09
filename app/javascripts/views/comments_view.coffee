require 'lib/radium/text_area'

Radium.CommentsView = Radium.View.extend
  commentTextArea: Radium.TextArea.extend(Ember.TargetActionSupport,
    placeholder: 'comment'
    valueBinding: 'controller.text'
    classNames: ['new-comment']
    target: 'controller'
    action: 'submit'

    click: (event) ->
      event.stopPropagation()

    insertNewline: ->
      @triggerAction()
  )
