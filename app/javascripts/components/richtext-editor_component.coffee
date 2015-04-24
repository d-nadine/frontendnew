Radium.RichtextEditorComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.AutocompleteMixin,
  Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,

  actions:
    setBindingValue: (placeholder) ->
      @onPlaceholderInserted(placeholder)
      @transitionToEditing()
      false

  classNameBindings: [':richtext-editor', 'isInvalid']
  btnSize: 'bth-xs'
  height: 120

  files: Ember.computed.alias 'targetObject.files'

  setup: Ember.on 'didInsertElement', ->
    textarea = @$('textarea')

    textarea.summernote
      height: @get('height')
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']]
        ['fontsize', ['fontsize']]
        ['color', ['color']]
        ['para', ['ul', 'ol', 'paragraph']]
        ['height', ['height']]
        ['insert', ['link', 'picture']]
        ['table', ['table']]
        ['help', ['help']]
        ['misc', ['codeview', 'undo', 'redo']]
      ]

    textarea.code @get('content')

    @$('.btn').addClass @get('btnSize')

    Ember.run.scheduleOnce 'afterRender', this, 'addOverrides'

    superFunc = @__nextSuper.bind this

    self = this

    Ember.run.next ->
      superFunc()

    return unless parent = @get('parent')

    parent.on "placeholderInsered", this, "onPlaceholderInserted"

  removePlaceHolder: ->
    editable = @$('.note-editable')
    editable.removeClass('placeholder')
    editable.html('')
    @set 'placeholderShown', true

  addOverrides: ->
    Ember.run.next =>
      typeahead = @getTypeahead()

      typeahead.show = @showTypeahead.bind(typeahead)

      typeaheadProcess = typeahead.process

      typeaheadHide = typeahead.hide

      typeahead.hide = =>
        @transitionToEditing()

        typeaheadHide.apply typeahead, arguments

      typeahead.process = =>
        return if @inEditingState()

        typeaheadProcess.apply typeahead, arguments

      typeaheadKeydown = typeahead.keydown.bind(typeahead)

      typeahead.keyDown = null

      typeahead.$element.off 'keydown'

      keyDownHanlder = (e) =>
        keyCode = e.keyCode

        if @inEditingState() || [@TAB, @ENTER, @ARROW_UP, @ARROW_DOWN].contains keyCode

          return typeaheadKeydown(e)

        if keyCode == @ESCAPE
          @transitionToEditing()
          return false

        if keyCode == @DELETE
          @query = @query.slice(0, (@query.length - 1))
          return false

        @query += String.fromCharCode(e.keyCode)

        return false

      typeahead.keydown = keyDownHanlder

      typeahead.$element.on 'keydown', keyDownHanlder.bind(typeahead)

      typeaheadBlur = typeahead.blur.bind(typeahead)

      typeahead.$element.off 'blur'

      blurHandler = (e) =>
        @transitionToEditing()
        false

      typeahead.blur = null

      typeahead.$element.on 'blur', blurHandler.bind(typeahead)

      typeahead.blur = typeaheadBlur.bind(typeahead)

    editable = @$('.note-editable')

    if tabindex = @get('tabindex')
      editable.attr('tabindex', tabindex)

    editable.addClass('placeholder').one 'focus', @removePlaceHolder.bind(this) unless @get('content.length')

    dropdowns = $('[data-toggle=dropdown]')

    dropdowns.dropdown()

    dropzone = @$(".note-dropzone")

    self = this

    drop = @richTextAreaDrop.bind this

    dropzone.off("drop").on "drop", drop

  richTextAreaDrop: (e) ->
    files = e.dataTransfer.files

    return unless files.length

    @uploadFiles files

    $(document).trigger('drop')

    e.preventDefault()
    false

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @$('.note-editable').off 'focus'
    @$('textarea').destroy()
    @$(".note-dropzone").off('drop')

  editorState: 'editing'

  inEditingState: ->
    @editorState == "editing"

  inTemplateSelection: ->
    @editorState == "templateSelection"

  transitionToEditing: ->
    @set 'editorState', 'editing'
    @query = ""
    @$('ul.typeahead').remove()

  keyDown: (e) ->
    return false if @inTemplateSelection()

    if e.keyCode == @OPEN_CURLY_BRACE
      @query = "{"
      @set 'editorState', "templateSelection"
      return false

    if e.keyCode == @DELETE
      range = Radium.rangy.getRange()

      parentNode = range.startContainer.parentNode

      return unless parentNode.className == "remove-template-item"

      $(parentNode.parentNode).remove()

      e.stopPropagation()
      return false

    @doUpdate()

  click: (e) ->
    if e.target.className == "remove-template-item"
      $(e.target.parentNode).remove()

      e.stopPropagation()
      return false

    @doUpdate()
    $('[data-toggle=dropdown]').each ->
      $(this).parents('.btn-group.open').removeClass 'open'

  doUpdate: ->
    content = @$('.note-editable').html()
    @set('content', content)

  onPlaceholderInserted: (placeholder) ->
    @removePlaceHolder() unless @get('placeholderShown')

    text = Radium.TemplatePlaceholderMap[placeholder.name]

    node = "<span class=\"badge badge-info template-item\">{#{text}|\"fall back\"}&nbsp;<span class=\"remove-template-item\" href=\"#\">x</span></span>"

    editable = @$('.note-editable')

    content = editable.html() + node + "&nbsp;"
    editable.html(content)

    editable.setEndOfContentEditble()
    @doUpdate()

  placeholderShown: false

  autocompleteElement: ->
    @$('.note-editable')

  showTypeahaedWhenEmpty: false

  showTypeahead: ->
    return if $('ul.typeahead').is(':visible')

    selection = Radium.rangy.getSelection()
    range = selection.getRangeAt(0).cloneRange()
    editor = $('.note-editable')

    lastNode = range.endContainer

    $.summernote.core.dom.insertAfter(@$menu.get(0), lastNode)

    positioning = if editor.is(':empty')
                    editor.position()
                  else
                    top: 'auto', left: 'auto'

    @$menu.css(top: positioning.top, left: positioning.left, display: 'inline-table')

    setTimeout =>
      @$menu.show()
    , 100

    @shown = true

    this
