require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'

Radium.EditableFieldComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    activateLink: ->
      target = @get('containingController')

      model = @get('model')

      return target.transitionToRoute model.humanize(), model

    updateModel: ->
      return if @get('isInvalid')
      return unless @get('bufferedProxy')

      modelValue = @get('model').get(@get('bufferKey')) || ''
      value = @get('bufferedProxy').get(@get('bufferKey')) || ''

      if $.trim(value).length || modelValue.length
        return Ember.run.debounce this, 'send', ['saveField'], 200

      return @send 'setPlaceholder'

    saveField: (item) ->
      bufferedProxy = @get('bufferedProxy')
      model = @get('model')

      return unless bufferedProxy.hasBufferedChanges

      bufferedProxy.applyBufferedChanges()

      @set 'isSaving', true

      model.one 'didUpdate', =>
        @set 'isSaving', false
        value = @get('model').get(@get('bufferKey'))
        unless value?.length
          @send 'setPlaceholder'

      model.one 'becameInvalid', =>
        bufferedProxy.discardBufferedChanges()
        @send 'flashError', model
        @set 'isSaving', false

      model.one 'becameError', =>
        bufferedProxy.discardBufferedChanges()
        @send 'flashError', "An error has occurred and the update could not be completed."
        @send 'isSaving', false

      @get('store').commit()

    setPlaceholder: ->
      @$().html("<em class='placeholder'>#{@get('placeholder')}</em>")
      false

  # hacky need to use controller of the table component for certain functions
  containingController: Ember.computed ->
    @get('targetObject.parentController.targetObject')

  classNameBindings: [':editable', 'isSaving', 'isInvalid']
  attributeBindings: ['contenteditable']
  isTransitioning: false

  contenteditable: Ember.computed "isSaving", ->
    "true" unless @get("isSaving")

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  store: Ember.computed ->
    @container.lookup "store:main"

  setup: Ember.on 'didInsertElement', ->
    @$().on 'focus', @focusContent.bind(this)

    bufferKey = @get('bufferKey')

    bufferDep = "bufferedProxy.#{bufferKey}"
    modelDep = "model.#{bufferKey}"

    route = "/#{@get('model').humanize().pluralize()}/#{@get('model.id')}"

    Ember.defineProperty this, 'markUp', Ember.computed bufferDep, modelDep, ->
      value = @get('bufferedProxy').get(@get('bufferKey'))

      return '' unless value

      "<a class='route' href='#{@get('route')}'>#{value}</a>"

    if @get('validator')
      Ember.defineProperty this, 'isInvalid', Ember.computed bufferDep, ->
        value = @get('bufferedProxy').get(@get('bufferKey'))

        return false unless value

        isInvalid = not @get('validator').test value

        isInvalid

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
    @get('bufferedProxy').set(@get('bufferKey'), @$().text())
    route = @get('route')
    @$().html @get('markUp')
    @setEndOfContentEditble()

  keyDown: (e) ->
    # sadly classNameBindings does not seem to
    # work with dynamic properties like isInvalid
    if @get('isInvalid')
      @$().addClass 'is-invalid'
    else
      @$().removeClass 'is-invalid'

    if e.keyCode == @ENTER
      Ember.run.next =>
        @send 'updateModel'
      return false

    if e.keyCode == @ESCAPE
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
    Ember.run.next =>
      @send 'updateModel'