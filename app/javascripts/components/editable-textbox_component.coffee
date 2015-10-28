require 'mixins/editable_mixin'

Radium.EditableTextboxComponent = Ember.TextField.extend Radium.EditableMixin,
  setMarkup: ->
    value = ( =>
      return unless potential = @get('bufferedProxy').get(@get('bufferKey'))

      if potential instanceof DS.Model
        # FIXME: need to configure other keys
        return potential.get('displayName')

      potential)() || ''

    @set('value', value)

  keyDown: (e) ->
    bufferedProxy = @get('bufferedProxy')

    if e.keyCode == @ENTER
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

  input: ->
    true


  focusOut: (e) ->
    @_super.apply this, arguments
    return unless @$().length

    el = @$()

    el.parents('td:first').removeClass('active')
