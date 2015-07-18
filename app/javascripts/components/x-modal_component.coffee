Radium.XModalComponent = Ember.Component.extend
  actions:
    closeModal: ->
      @sendAction "close"

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @$('.modal').addClass('in')

  destroy: ->
    if @get('_state') isnt 'inDOM' then @_super()

    unless modal = @$('.modal')
      return

    modal.removeClass('in')

    # FIXME: __nextSuper will break in a future
    # ember release
    superFunction = @__nextSuper.bind this

    modal.one $.support.transition.end, superFunction

