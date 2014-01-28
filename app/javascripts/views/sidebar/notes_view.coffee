Radium.SidebarNotesView = Radium.InlineEditorView.extend
  textArea: Radium.TextArea.extend(Ember.TargetActionSupport,
     click: (event) ->
      event.stopPropagation()

    insertNewline: ->
      @get('parentView').send 'toggleEditor'
  )
