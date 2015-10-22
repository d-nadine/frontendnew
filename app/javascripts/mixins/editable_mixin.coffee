require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'
require 'mixins/containing_controller_mixin'

Radium.EditableMixin = Ember.Mixin.create Radium.KeyConstantsMixin,
  Radium.ContainingControllerMixin,

  actions:
    updateModel: ->
      return if @get('actionOnly')

      unless bufferedProxy = @get('bufferedProxy')
        return

      modelValue = @get('model')?.get(@get('bufferKey')) || ''
      value = bufferedProxy.get(@get('bufferKey')) || ''

      unless bufferedProxy.hasBufferedChanges
        @send('setPlaceholder') if bufferedProxy.get('isNew') || !value.length
        return

      if $.trim(value).length || modelValue.length
        return Ember.run.debounce this, 'send', ['saveField'], 200

      return @send 'setPlaceholder'

    saveField: (item) ->
      unless @get('isSaving')
        return @completeSave()

      observer = =>
        return if @get('isSaving')

        @removeObserver "isSaving", observer

        @completeSave()

      @addObserver 'isSaving', observer

  completeSave: (item) ->
    bufferedProxy = @get('bufferedProxy')

    return unless bufferedProxy

    bufferKey = @get('bufferKey')

    model = @get('model')

    nullModelType = @get('nullModelType')

    if !model && nullModelType
      model = nullModelType.createRecord()
      bufferedProxy.set('content', model)
      @set 'model', model
      @notifyPropertyChange 'model'
      @notifyPropertyChange 'bufferedProxy'
      @notifyPropertyChange "bufferedProxy.#{bufferKey}"

    unless model
      return @flashMessenger.error "No model is associated with this record"

    return unless bufferedProxy.hasBufferedChanges

    backup = model.get(bufferKey)

    resetModel = =>
      bufferedProxy.discardBufferedChanges()
      bufferedProxy.set bufferKey, backup
      model.set bufferKey, backup
      model.reset()
      markUp = @get('markUp')

      return @setMarkup()

    if @get('isInvalid')
      @get('containingController').send 'flashError', 'Field is not valid.'
      @set 'isNewSelection', false
      if model
        return resetModel()
      else
        return

    @set 'isSaving', true

    if saveAction = @get("saveAction")
      @get('containingController').send saveAction, this
      if @get('actionOnly')
        @set 'isNewSelection', false
        return

    bufferedProxy.applyBufferedChanges()

    if beforeSave = @get('beforeSave')
      @get('containingController').send beforeSave, this

    self = this

    model.save().then( =>
      @set 'isSaving', false
      value = @get('model').get(@get('bufferKey'))

      Ember.run.next ->
        model.trigger 'modelUpdated', self, model

      if afterSave = @get('afterSave')
        @get('containingController').send afterSave, this

      unless value?.length
        return @send 'setPlaceholder'

      observer = =>
        return unless model.currentState.stateName == "root.loaded.saved"
        model.removeObserver "currentState.stateName", observer
        if @get('alternativeRoute')
          @notifyPropertyChange 'model'
          @$().html self.get('markUp')

      if model.currentState.stateName == "root.loaded.saved"
        observer()
      else
        model.addObserver "currentState.stateName", observer
    ).finally =>
      @set 'isNewSelection', false
      @set 'isSaving', false

  classNames: ['editable']
  classNameBindings: ['isSaving', 'isInvalid']

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    modelDep = "model.#{bufferKey}"
    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"
    bufferedProxy = @get('bufferedProxy')

    @createCustomProperties(modelDep, bufferKey, bufferDep)

    return unless @get('validator') || @get('isRequired')

    if validator = @get('validator')
      if typeof validator == "string"
        validatorRegex = new RegExp(validator)
      else
        validatorRegex = validator

    Ember.defineProperty this, 'isInvalid', Ember.computed bufferDep, 'isRequired', ->
      value = @get('bufferedProxy').get(bufferKey)

      if @get('isRequired') && !value
        return true

      return false unless value

      return false unless validatorRegex

      isInvalid = not validatorRegex.test value

      isInvalid


  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$().on 'focus', @focusContent.bind(this)

    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    modelDep = "model.#{bufferKey}"

    unless model = @get('model')
      return @setMarkup()

    model.on 'modelUpdated', @modelUpdated.bind(this)

    observer = =>
      return unless model.get('isLoaded')

      @notifyPropertyChange modelDep

      @setMarkup()

      model.removeObserver 'isLoaded', observer

    return unless model

    unless model.get('isLoaded')
      Ember.run.next =>
        @isLoadingDisplay()
        model.addObserver 'isLoaded', observer
        return
    else
      @setMarkup()

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$()?.off 'focus', @focusContent.bind(this)

    return unless model = @get('model')

    model.off 'modelUpdated'

  modelUpdated: (raiser, model) ->
    return if @isDestroyed || @isDestroying
    return if raiser == this

    @setMarkup(true)

  focusContent: (e) ->
    return unless @$().length
    el = $(@$())

    value = @get('bufferedProxy').get(@bufferKey)

    unless value
      el.empty()

    el.parents('td:first').addClass('active')

  isRequired: false

  createCustomProperties: ->
    null

  isLoadingDisplay: ->
    null

  keyDown: (e) ->
    throw new Error("you need to implement keyDown")

  input: (e) ->
    throw new Error("you need to implement input")

  setMarkup: ->
    throw new Error("you need to implement setMarkup")

  focusOut: (e) ->
    Ember.run.next =>
      @send 'updateModel'
