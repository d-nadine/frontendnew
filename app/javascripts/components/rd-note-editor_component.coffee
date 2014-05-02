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
    $('body').on 'click.rd-note-editor', =>
      return unless @get('isEditing')
      @send 'save'
  ).on 'didInsertElement'

  teardown: (->
    $('body').off 'click.rd-note-editor'
  ).on 'willDestroyElement'

  actions:
    edit: ->
      @set 'isEditing', true
    save: ->
      return unless @get('isDirty')
      @set 'isEditing', false

      @get('buffer').applyBufferedChanges()
      note = @get('note.content')

      note.one "didError", ->
        alert('ploblemo')
        note.rollback()
      note.one "becameInvalid", ->
        alert('ploblemo')
        note.rollback()
      @get('store').commit()
      
    cancel: ->
      return unless @get('isEditing')
      @get('buffer').discardBufferedChanges()
      @set 'isEditing', false
