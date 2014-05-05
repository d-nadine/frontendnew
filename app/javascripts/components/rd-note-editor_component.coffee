Radium.RdNoteEditorComponent = Ember.Component.extend
  classNames: ['rd-note-editor']
  classNameBindings: ['isEditing', 'isDirty']
  isEditing: false
  isDirty: Ember.computed.readOnly 'buffer.hasBufferedChanges'
  buffer: Ember.computed('note', ->
    BufferedObjectProxy.create content: @get 'note'
  )

  store: Ember.computed ->
    this.container.lookup "store:main"

  setup: (->
    Ember.oneWay this, 'hasFocus', 'isEditing'
  ).on 'didInsertElement'

  focusOut: (e)->
    Ember.run.next => @send 'save'

  actions:
    edit: ->
      @set 'isEditing', true
    save: ->
      return unless @get('isDirty') || @get('isCancelling')
      @set 'isEditing', false
      @get('buffer').applyBufferedChanges()

      @sendAction 'save', @get('note.content')

    cancel: ->
      return unless @get('isEditing')
      @get('buffer').discardBufferedChanges()
      @set 'isEditing', false
      @set 'isCancelling', true
      Ember.run.next => @set 'isCancelling', false
