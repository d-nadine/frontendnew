require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'
require 'mixins/content_editable_behaviour'

Radium.EditableFieldComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,
  actions:
    activateLink: ->
      target = @get('containingController')

      routable = if alternative = @get('alternativeRoute')
                   @get('model').get(alternative)
                 else
                   @get('model')

      if queryParams = @get('queryParams')
        target.transitionToRoute routable.humanize(), routable, queryParams: queryParams
      else
        target.transitionToRoute routable.humanize(), routable

    updateModel: ->
      if @get('isInvalid')
        return @get('containingController').send 'flashError', 'Field is not valid.'

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
      return if @get('isSaving')

      bufferedProxy = @get('bufferedProxy')

      return unless bufferedProxy

      bufferKey = @get('bufferKey')

      return unless bufferedProxy.hasBufferedChanges

      if @get('isInvalid')
        return @get('containingController').send 'flashError', 'Field is not valid.'

      @set 'isSaving', true

      model = @get('model')

      if saveAction = @get("saveAction")
        @get('containingController').send saveAction, this

      bufferedProxy.applyBufferedChanges()

      self = this

      model.save().then( =>
        @set 'isSaving', false
        value = @get('model').get(@get('bufferKey'))
        unless value?.length
          return @send 'setPlaceholder'

        if @get('alternativeRoute')
          model.one 'didReload', ->
            self.notifyPropertyChange 'model'
            self.$().html self.get('markUp')
            self.setEndOfContentEditble()

          model.reload()
      ).catch((error) ->
        bufferedProxy.discardBufferedChanges()
      ).finally =>
        @set 'isSaving', false

    setPlaceholder: ->
      @$().html("<em class='placeholder'>#{@get('placeholder')}</em>")
      false

  # hacky need to use controller of the table component for certain functions
  containingController: Ember.computed ->
    if parent = @get('parent')
      parent
    else
      @get('targetObject.parentController.targetObject')

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
      value = @get('bufferedProxy').get(@get('bufferKey'))

      return '' unless value

      if @get('route')
        "<a class='route' href='#{@get('route')}'>#{value}</a>"
      else
        value

    unless validator = @get('validator')
      return

    Ember.defineProperty this, 'isInvalid', Ember.computed bufferDep, ->
      value = @get('bufferedProxy').get(bufferKey)

      return false unless value

      isInvalid = not validator.test value

      isInvalid

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$().parent().on 'click', @clickHandler.bind(this)

    @$().on 'focus', @focusContent.bind(this)

    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    modelDep = "model.#{bufferKey}"

    model = @get('model')

    observer = =>
      return unless model.get('isLoaded')

      @notifyPropertyChange modelDep

      @setMarkup()

      model.removeObserver 'isLoaded', observer

    return unless model

    unless model.get('isLoaded')
      Ember.run.next =>
        @$().html("<em class='loading'>loading....</em>")
        model.addObserver 'isLoaded', observer
        return
    else
      @setMarkup()

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$()?.parent().off 'click'
    @$()?.off 'focus', @focusContent.bind(this)

  setMarkup: ->
    markUp = @get('markUp')

    unless markUp?.length
      @send 'setPlaceholder'
    else
      @$().html markUp

    @setEndOfContentEditble()

  input: (e) ->
    text =  if @get('multiline')
              @$().html()
            else
              @$().text()

    @get('bufferedProxy').set(@get('bufferKey'), text)
    @$().html @get('markUp')
    @setEndOfContentEditble()

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
    if $(e.target).hasClass 'route'
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
