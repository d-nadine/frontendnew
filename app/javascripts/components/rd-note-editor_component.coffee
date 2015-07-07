Radium.RdNoteEditorComponent = Ember.Component.extend
  classNameBindings: [':rd-note-editor', 'isEditing', 'isDirty']
  isEditing: false
  isDirty: Ember.computed.readOnly 'buffer.hasBufferedChanges'
  buffer: Ember.computed('note', ->
    BufferedObjectProxy.create content: @get 'note'
  )

  setup: Ember.on 'didInsertElement', ->
    Ember.oneWay this, 'hasFocus', 'isEditing'

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
