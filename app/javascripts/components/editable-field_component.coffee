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

      return unless bufferedProxy.hasBufferedChanges
        @send('setPlaceholder') if bufferedProxy.get('isNew') && !value.length
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

  # we need to start with false for ellipsis bug in IE and safari
  contenteditable: "false"

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
    @$().parent().on 'click', @clickHandler.bind(this)

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
    @_super.apply this, arguments
    @$()?.parent().off 'click'
    @$()?.off 'focus', @focusContent.bind(this)

  input: (e) ->
    text =  @$().text()
    @get('bufferedProxy').set(@get('bufferKey'), @$().text())
    route = @get('route')
    @$().html @get('markUp')
    @setEndOfContentEditble()
    a = @$('a.route')

  keyDown: (e) ->
    # sadly classNameBindings does not seem to
    # work with dynamic properties like isInvalid
    if @get('isInvalid')
      @$().addClass 'is-invalid'
    else
      @$().removeClass 'is-invalid'

    bufferedProxy = @get('bufferedProxy')

    if e.keyCode == @ENTER
      Ember.run.next =>
        @send 'updateModel'
      @$().blur()
      return false

    if e.keyCode == @ESCAPE
      bufferedProxy.discardBufferedChanges()
      @$().html @get('markUp')
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
    if $(el.html()).hasClass('placeholder')
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
