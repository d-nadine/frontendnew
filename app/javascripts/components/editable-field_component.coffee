require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'
require 'mixins/content_editable_behaviour'
require 'mixins/containing_controller_mixin'

Radium.EditableFieldComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,
  Radium.ContainingControllerMixin,
  actions:
    activateLink: ->
      target = @get('containingController')

      if routeAction = @get("routeAction")
        return target.send routeAction, @get('model')

      routable = if alternative = @get('alternativeRoute')
                   @get('model').get(alternative)
                 else
                   @get('model')

      if queryParams = @get('queryParams')
        target.transitionToRoute routable.humanize(), routable, queryParams: queryParams
      else
        target.transitionToRoute routable.humanize(), routable

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

    setPlaceholder: ->
      return unless el = @$()

      el.html("<em class='placeholder'>#{@get('placeholder')}</em>")
      false

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
  attributeBindings: ['contenteditable']
  isTransitioning: false

  # we need to start with false for ellipsis bug in IE and safari
  contenteditable: "false"

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  route: Ember.computed "model", 'alternativeRoute', 'notRoutable', ->
    return if @get('notRoutable')

    routable = if alternative = @get('alternativeRoute')
                 if alternative = @get('model').get(alternative)
                   alternative
               else
                 @get('model')

    return unless routable

    "/#{routable.humanize().pluralize()}/#{routable.get('id')}"

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    modelDep = "model.#{bufferKey}"
    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    Ember.defineProperty this, 'markUp', Ember.computed bufferDep, 'route', 'alternativeRoute', modelDep, ->
      value = ((o) =>
        return unless potential = @get('bufferedProxy').get(@get('bufferKey'))

        if potential instanceof DS.Model
          # FIXME: need to configure other keys
          return potential.get('displayName')

        potential)()

      return '' unless value

      if @get('route')
        "<a class='route' href='#{@get('route')}'>#{value}</a>"
      else if @get('externalUrl')
        url = Radium.Url.resolve value
        "<a href='#{url}' target='_blank'>#{value}</a>"
      else
        value

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

    @$().parent().on 'click', @clickHandler.bind(this)

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
        @$().html("<em class='loading'>Loading....</em>")
        model.addObserver 'isLoaded', observer
        return
    else
      @setMarkup()

  modelUpdated: (raiser, model) ->
    return if @isDestroyed || @isDestroying
    return if raiser == this

    @setMarkup(true)

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$()?.parent().off 'click'
    @$()?.off 'focus', @focusContent.bind(this)

    return unless model = @get('model')

    model.off 'modelUpdated'

  setMarkup: (dont = false) ->
    markUp = @get('markUp')

    return unless el = @$()

    unless markUp?.length
      @send 'setPlaceholder'
    else
      el.html markUp

    @setEndOfContentEditble() unless dont

  input: (e) ->
    text =  if @get('multiline')
              @$().html()
            else
              @$().text()

    @get('bufferedProxy').set(@get('bufferKey'), text)

    el = @$()

    anchor = el.find('a')

    updateEl = if anchor.length
                 anchor
               else
                 el

    updateEl.html @get('value')

  keyDown: (e) ->
    bufferedProxy = @get('bufferedProxy')

    if e.keyCode == @ENTER
      if @get('multiline')
        e.preventDefault()
        @insertLineBreak()
        return false
      Ember.run.next =>
        @send 'updateModel'
      @$().blur()
      return false

    if e.keyCode == @ESCAPE
      bufferedProxy.discardBufferedChanges()
      markUp = @get('markUp')

      @setMarkup()

      return false

    true

  clickHandler: (e) ->
    return if @contenteditable == "true"

    if $(e.target).hasClass('route')
      @send 'activateLink'
      return false

    @enableContentEditable()

  enableContentEditable: ->
    return unless @$().length

    el = @$()
    parent = el.parent()

    parent.css('text-overflow','clip')

    Ember.run =>
      @set "contenteditable", "true"

    Ember.run.next =>
      @setEndOfContentEditble()
      parent.scrollLeft(el.width())

  focusContent: (e) ->
    return unless @$().length
    el = $(@$())

    value = @get('bufferedProxy').get(@bufferKey)

    unless value
      el.empty()

    el.parents('td:first').addClass('active')

    @enableContentEditable()

  focusOut: (e) ->
    Ember.run.next =>
      @send 'updateModel'

    return unless @$().length

    el = @$()

    @set "contenteditable", "false"
    el.parents('td:first').removeClass('active')
    el.parent().css('text-overflow','ellipsis')

    @send "updateModel"

  isRequired: false
