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

      unless bufferedProxy = @get('bufferedProxy')
        return

      modelValue = @get('model')?.get(@get('bufferKey')) || ''
      value = bufferedProxy.get(@get('bufferKey')) || ''

      return unless bufferedProxy.hasBufferedChanges
        @send('setPlaceholder') if bufferedProxy.get('isNew') && !value.length
        return

      if $.trim(value).length || modelValue.length
        return Ember.run.debounce this, 'send', ['saveField'], 200

      return @send 'setPlaceholder'

    saveField: (item) ->
      bufferedProxy = @get('bufferedProxy')
      bufferKey = @get('bufferKey')
      isNew = bufferedProxy.get('isNew')

      if isNew
        value = bufferedProxy.get(@get('bufferKey'))

        if parent = @get('parent')
          parentAccessor = @get('parentAccessor')
          Ember.assert "You must have a parentAccessor binding for a parent", parentAccessor
          parent.set parentAccessor, value
          model = parent
        else
          newRecord = @get('newType').createRecord()
          newRecord.set bufferKey, value
          @set 'bufferedProxy.content', newRecord
          @set 'model', newRecord
      else
        model = @get('model')

      return unless bufferedProxy.hasBufferedChanges

      bufferedProxy.applyBufferedChanges()

      @set 'isSaving', true

      success = =>
        if isNew
          parent = @get('parent')
          parent.one 'didReload', =>
            @set 'isSaving', false
            updated = @get('parent').get(@get('loadAccessor'))
            @set 'model', updated
            @notifyPropertyChange "model"
            @set 'bufferedProxy.content', updated
            @$().html "<a class='route' href='#{@get('route')}'>#{bufferedProxy.get(bufferKey)}</a>"
          parent.reload()
        else
          @set 'isSaving', false
          value = @get('model').get(@get('bufferKey'))
          unless value?.length
            @send 'setPlaceholder'

      model.one 'didCreate', success

      model.one 'didUpdate', success

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

    Ember.defineProperty this, 'markUp', Ember.computed bufferDep, 'route', modelDep, ->
      value = @get('bufferedProxy').get(@get('bufferKey'))

      return '' unless value

      unless @get('bufferedProxy.isNew')
        "<a class='route' href='#{@get('route')}'>#{value}</a>"
      else
        value

    if @get('validator')
      Ember.defineProperty this, 'isInvalid', Ember.computed bufferDep, ->
        value = @get('bufferedProxy').get(@get('bufferKey'))

        return false unless value

        isInvalid = not @get('validator').test value

        isInvalid

    model = @get('model')

    setMarkup = =>
      markUp = @get('markUp')

      unless markUp?.length
        @send 'setPlaceholder'
      else
        @$().html markUp

    observer = =>
      return unless model.get('isLoaded')

      @notifyPropertyChange modelDep

      setMarkup()
      model.removeObserver 'isLoaded', observer

    unless model
      Ember.assert 'You must assign a newType binding if the model can be null.', @get('newType')
      placeHolder = {isNew: true}
      placeHolder[bufferKey] = null
      @get('bufferedProxy').set('content', placeHolder)
      return setMarkup()

    unless model.get('isLoaded')
      Ember.run.next =>
        @$().html("<em class='loading'>loading....</em>")
        model.addObserver 'isLoaded', observer
        return
    else
      setMarkup()

  teardown: Ember.on 'willDestroyElement', ->
    @$()?.off 'focus', @focusContent.bind(this)

  route: Ember.computed "model", ->
    return if !@get('model') || @get('model.isNew')

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