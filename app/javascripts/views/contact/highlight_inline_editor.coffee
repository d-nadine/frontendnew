Radium.HighlightInlineEditor = Radium.InlineEditorView.extend
  isValid: true

  click: (evt) ->
    tagName = evt.target.tagName.toLowerCase()

    if ['input', 'button', 'span',  'i', 'a'].indexOf(tagName) == -1
      @_super.apply this, arguments
      return

    evt.preventDefault()
    evt.stopPropagation()

  keyDown: (evt) ->
    return unless evt.target.tagName.toLowerCase() == 'input'

    return if [13, 9].indexOf(evt.keyCode) == -1

    @toggleEditor()

  toggleEditor:  (evt) ->
    @_super.apply this, arguments

    return unless @get 'isEditing'
    Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

  highlightSelection: ->
    @$('input[type=text],textarea').filter(':first').select()

