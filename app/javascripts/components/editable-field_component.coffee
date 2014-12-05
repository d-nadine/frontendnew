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
        value = @get('model').get(@get('bufferKey'))
        unless value?.length
          @send 'setPlaceholder'

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

    value = @get('model').get(@get('bufferKey'))

    unless value?.length
      @send 'setPlaceholder'
    else
      @$().text(value)

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
    modelValue = @get('model').get(@get('bufferKey')) || ''
    value = @get('buffer').get(@get('bufferKey')) || ''

    if $.trim(value).length || modelValue.length
      return Ember.run.debounce this, 'send', ['saveField'], 200

    return @send 'setPlaceholder'