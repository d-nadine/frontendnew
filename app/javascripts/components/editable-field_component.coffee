require 'lib/radium/buffered_proxy'
require 'components/key_constants_mixin'

Radium.EditableFieldComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    activateLink: ->
      target = @get('containingController')

      routable = if alternative = @get('alternativeRoute')
                   @get('model').get(alternative)
                 else
                   @get('model')

      return target.transitionToRoute routable.humanize(), routable

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

      return unless bufferedProxy

      bufferKey = @get('bufferKey')

      return unless bufferedProxy.hasBufferedChanges

      @set 'isSaving', true

      model = @get('model')

      self = this

      success = (result) ->
        self.set 'isSaving', false
        value = self.get('model').get(self.get('bufferKey'))
        unless value?.length
          return self.send 'setPlaceholder'

        if self.get('alternativeRoute')
          model.one 'didReload', ->
            self.notifyPropertyChange 'model'
            self.$().html self.get('markUp')

          model.reload()

      if containingAction = @get("save#{bufferKey.capitalize()}")
        @get('containingController').send containingAction, this

      bufferedProxy.applyBufferedChanges()

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

  classNames: ['editable']
  classNameBindings: ['isSaving', 'isInvalid']
  attributeBindings: ['contenteditable']
  isTransitioning: false

  contenteditable: Ember.computed "isSaving", ->
    "true" unless @get("isSaving")

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  route: Ember.computed "model", 'alternativeRoute', ->
    routable = if alternative = @get('alternativeRoute')
                 if alternative = @get('model').get(alternative)
                   alternative
               else
                 @get('model')

    return unless routable

    "/#{routable.humanize().pluralize()}/#{routable.get('id')}"

  setup: Ember.on 'didInsertElement', ->
    @$().on 'focus', @focusContent.bind(this)

    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    modelDep = "model.#{bufferKey}"

    Ember.defineProperty this, 'markUp', Ember.computed bufferDep, 'route', 'alternativeRoute', modelDep, ->
      value = @get('bufferedProxy').get(@get('bufferKey'))

      return '' unless value

      if @get('route')
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

    unless model.get('isLoaded')
      Ember.run.next =>
        @$().html("<em class='loading'>loading....</em>")
        model.addObserver 'isLoaded', observer
        return
    else
      setMarkup()

  teardown: Ember.on 'willDestroyElement', ->
    @$()?.off 'focus', @focusContent.bind(this)

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
    return unless @$().length
    el = $(@$())
    if $(el.html()).hasClass('placeholder')
      el.empty()

    el.parents('td:first').addClass('active')

    @setEndOfContentEditble()

  focusOut: (e) ->
    Ember.run.next =>
      @send 'updateModel'

    return unless @$().length

    @$().parents('tD:first').removeClass('active')
