require 'mixins/content_editable_behaviour'
require 'mixins/containing_controller_mixin'
require 'mixins/editable_mixin'

Radium.EditableFieldComponent = Ember.Component.extend Radium.ContentEditableBehaviour,
  Radium.EditableMixin,
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

    setPlaceholder: ->
      return unless el = @$()

      el.html("<em class='placeholder'>#{@get('placeholder')}</em>")
      false

  attributeBindings: ['contenteditable']
  isTransitioning: false

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$().parent().on 'click', @clickHandler.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @$()?.parent().off 'click'

  # we need to start with false for ellipsis bug in IE and safari
  contenteditable: "false"

  route: Ember.computed "model", 'alternativeRoute', 'notRoutable', ->
    return if @get('notRoutable')

    routable = if alternative = @get('alternativeRoute')
                 if alternative = @get('model').get(alternative)
                   alternative
               else
                 @get('model')

    return unless routable

    "/#{routable.humanize().pluralize()}/#{routable.get('id')}"

  createCustomProperties: (modelDep, bufferKey, bufferDep) ->
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
      else if @get('routeAction')
        "<a class='route' href='#'>#{value}</a>"
      else if @get('externalUrl')
        url = Radium.Url.resolve value
        "<a href='#{url}' target='_blank'>#{value}</a>"
      else
        value

  isLoadingDisplay: ->
    @$().html("<em class='loading'>Loading....</em>")

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
    @_super.apply this, arguments

    @enableContentEditable()

  focusOut: (e) ->
    @_super.apply this, arguments
    return unless @$().length

    el = @$()

    @set "contenteditable", "false"
    el.parents('td:first').removeClass('active')
    el.parent().css('text-overflow','ellipsis')
