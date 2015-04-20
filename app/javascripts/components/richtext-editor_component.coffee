Radium.RichtextEditorComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.AutocompleteMixin,
  Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,

  actions:
    setBindingValue: (value) ->
      p value

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

      typeahead.show = @showTypeahead.bind(typeahead, @getCaretCharacterOffsetWithin)

      typeaheadKeydown = typeahead.keydown.bind(typeahead)

      typeahead.keyDown = null

      typeahead.$element.off 'keydown'

      keyDownHanlder = (e) =>
        keyCode = e.keyCode

        if @inEditingState() || [@TAB, @ENTER, @ARROW_UP, @ARROW_DOWN].contains keyCode

          return typeaheadKeydown(e)

        if keyCode == @ESCAPE
          @set 'editorState', 'editing'
          typeahead.blur()
          @query = ""
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
        @set 'editorState', 'editing'
        @query = ""
        typeaheadBlur()

      typeahead.blur = null

      typeahead.$element.on 'blur', blurHandler.bind(typeahead)

      typeahead.blur = typeaheadBlur.bind(typeahead)

    editable = @$('.note-editable')

    if tabindex = @get('tabindex')
      editable.attr('tabindex', tabindex)

    editable.addClass('placeholder').one 'focus', @removePlaceHolder.bind(this)

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

  keyDown: (e) ->
    return false if @inTemplateSelection()

    if e.keyCode == @OPEN_CURLY_BRACE
      @query = "{"
      @set 'editorState', "templateSelection"
      return false

    @doUpdate()

  click: (e) ->
    @doUpdate()
    $('[data-toggle=dropdown]').each ->
      $(this).parents('.btn-group.open').removeClass 'open'

  doUpdate: ->
    content = @$('.note-editable').html()
    @set('content', content)

  onPlaceholderInserted: (key) ->
    @removePlaceHolder() unless @get('placeholderShown')

    text = Radium.TemplatePlaceholderMap[key]

    text = "{#{text}|\"fallback\"}"

    editable = @$('.note-editable')

    content = editable.html() + text
    editable.html(content)

    editable.setEndOfContentEditble()
    @doUpdate()

  placeholderShown: false

  autocompleteElement: ->
    @$('.note-editable')

  showTypeahaedWhenEmpty: false

  showTypeahead: (getSelectionCoords) ->
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
