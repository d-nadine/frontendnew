require 'lib/radium/buffered_proxy'

Radium.EditableFieldComponent = Ember.Component.extend
  actions:
    saveField: (item) ->
      buffer = @get('buffer')
      model = @get('model')

      return unless buffer.hasBufferedChanges

      buffer.applyBufferedChanges()

      @set 'isSaving', true

      model.one 'didUpdate', =>
        @set 'isSaving', false

      model.one 'becameInvalid', =>
        buffer.discardBufferedChanges()
        @send 'flashError', model
        @set 'isSaving', false

      model.one 'becameError', =>
        buffer.discardBufferedChanges()
        @send 'flashError', "An error has occurred and the update could not be completed."
        @send 'isSaving', false

      @get('store').commit()

    setPlaceholder: ->
      @$().html("<em class='placeholder'>#{@get('placeholder')}</em>")
      false

  classNameBindings: [':editable', 'isSaving']
  attributeBindings: ['contenteditable']
  contenteditable: Ember.computed "isSaving", ->
    "true" unless @get("isSaving")

  buffer: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  store: Ember.computed ->
    @container.lookup "store:main"

  setup: Ember.on 'didInsertElement', ->
    @$().on 'focus', @focusContent.bind(this)

    unless @get('value')?.length
      @send 'setPlaceholder'
    else
      @$().html(@get('value'))

  input: (e) ->
    @get('buffer').set(@get('bufferKey'), @$().text())

  focusContent: (e) ->
    el = $(@$())
    if $(el.html()).hasClass('placeholder')
      el.empty()
      range = document.createRange()
      range.selectNodeContents(el.get(0))
      sel = window.getSelection()
      sel.removeAllRanges()
      sel.addRange(range)

  focusOut: (e) ->
    value = @get('buffer').get(@get('bufferKey')) || ''

    unless $.trim(value).length
      return @send 'setPlaceholder'

    Ember.run.debounce this, 'send', ['saveField'], 200
