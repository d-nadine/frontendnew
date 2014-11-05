Radium.RichtextEditorComponent = Ember.Component.extend
  classNameBindings: [':richtext-editor', 'isInvalid']
  btnSize: 'bth-xs'
  height: 120

  setup: (->
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

    Ember.run.scheduleOnce 'afterRender', this, 'addBootstrapDropdown'
  ).on 'didInsertElement'

  addBootstrapDropdown: ->
    if tabindex = @get('tabindex')
      @$('.note-editable').attr('tabindex', tabindex)

    dropdowns = $('[data-toggle=dropdown]')

    dropdowns.dropdown()

  teardown: (->
    @$('textarea').destroy()
  ).on 'willDestroyElement'

  keyUp: ->
    @doUpdate()

  click: (e) ->
    @doUpdate()
    $('[data-toggle=dropdown]').each ->
      $(this).parents('.btn-group.open').removeClass 'open'

  doUpdate: ->
    content = @$('.note-editable').html()
    @set('content', content)