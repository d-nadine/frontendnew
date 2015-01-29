Radium.RdNoteEditorComponent = Ember.Component.extend
  classNameBindings: [':rd-note-editor', 'isEditing', 'isDirty']
  isEditing: false
  isDirty: Ember.computed.readOnly 'buffer.hasBufferedChanges'
  buffer: Ember.computed('note', ->
    BufferedObjectProxy.create content: @get 'note'
  )

  setup: Ember.on 'didInsertElement', ->
    Ember.oneWay this, 'hasFocus', 'isEditing'

  ##
  # NoteEditor listens for focus out from its input so that it can
  # auto-save. There are some problems with this approach which I'll
  # outline here:
  #
  # 1) the focusOut event is always fired twice.
  # 2) the focusOut event is always fired before any other events
  #
  # So, no matter what you do, the focusOut is always fired before any
  # other actions, including cancel. To get around this, we debounce
  # and delay the call to save by 200ms, so that if the focusOut
  # occured because of a click on the cancel button, the cancel will
  # have been fired before the save occurs. 
  focusOut: (e)->
    Ember.run.debounce this, 'send', ['save'], 200

  actions:
    edit: ->
      @set 'isEditing', true

    save: ->
      return if @isDestroyed

      @set 'isEditing', false
      return unless @get('isDirty')
      @get('buffer').applyBufferedChanges()

      @sendAction 'save', @get('note')

    delete: ->
      @get('buffer').discardBufferedChanges()
      @set 'isEditing', false
      @sendAction 'delete', @get('note')

    cancel: ->
      return unless @get('isEditing')
      @get('buffer').discardBufferedChanges()
      @set 'isEditing', false
