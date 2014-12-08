require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'

Radium.EditableFieldComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    activateLink: ->
      # hacky need to use controller of the table component to transitionToRoute
      target = @get('targetObject.parentController.targetObject')

      model = @get('model')

      return target.transitionToRoute model.humanize(), model

    updateModel: ->
      modelValue = @get('model').get(@get('bufferKey')) || ''
      value = @get('buffer').get(@get('bufferKey')) || ''

      if $.trim(value).length || modelValue.length
        return Ember.run.debounce this, 'send', ['saveField'], 200

      return @send 'setPlaceholder'

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

    bufferKey = @get('bufferKey')

    bufferDep = "buffer.#{bufferKey}"
    modelDep = "model.#{bufferKey}"

    route = "/#{@get('model').humanize().pluralize()}/#{@get('model.id')}"

    Ember.defineProperty this, 'markUp', Ember.computed bufferDep, modelDep, ->
      value = @get('buffer').get(@get('bufferKey'))

      return '' unless value

      "<a class='route' href='#{@get('route')}'>#{value}</a>"

    markUp = @get('markUp')

    unless markUp?.length
      @send 'setPlaceholder'
    else
      @$().html markUp

  teardown: Ember.on 'willDestroyElement', ->
    @$()?.off 'focus', @focusContent.bind(this)

  route: Ember.computed "model", ->
    "/#{@get('model').humanize().pluralize()}/#{@get('model.id')}"

  input: (e) ->
    text =  @$().text()
    @get('buffer').set(@get('bufferKey'), @$().text())
    route = @get('route')
    @$().html @get('markUp')
    @setEndOfContentEditble()

  keyDown: (e) ->
    if e.keyCode == @ENTER
      @send 'updateModel'
      return false

    true

  click: (e) ->
    if $(e.target).hasClass 'route'
      @send 'activateLink'
      return false

  setEndOfContentEditble: ->
    range = document.createRange()
    range.selectNodeContents(@$().get(0))
    range.collapse(false)
    selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange(range);

  focusContent: (e) ->
    el = $(@$())
    if $(el.html()).hasClass('placeholder')
      el.empty()
      @setEndOfContentEditble

  focusOut: (e) ->
    @send 'updateModel'