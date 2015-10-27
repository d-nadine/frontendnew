Radium.XModalComponent = Ember.Component.extend
  actions:
    closeModal: ->
      @sendAction "close"

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    modal = @$('.modal')

    modal.addClass('in')

    self = this

    Ember.run.next ->
      if anchor = self.get('anchor')
        anchorEl = $(anchor)

        Ember.assert "You must set a proper anchor selector", anchorEl.length

        modal = $('.modal.fade.in')

        Ember.assert "We have not found the modal to anchor", modal.length

        rect = anchorEl.get(0).getBoundingClientRect()

        left = rect.left + modal.width()

        modal.css({left: left, top: rect.top})

      overlay = $('.modal-backdrop')

      overlay.on 'click', (e) ->
        if $(e.target).parents('.modal.fade').length
          return true

        self.send "closeModal"

        self.set 'overlay', overlay

        e.stopPropagation()
        e.preventDefault()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    return unless overlay = @get('overlay')

    overlay.off 'click'

  destroy: ->
    @_super()

    if @get('_state') isnt 'inDOM' then @_super()

    unless modal = @$('.modal')
      return

    modal.removeClass('in')

    # FIXME: __nextSuper will break in a future
    # ember release
    superFunction = @__nextSuper.bind this

    modal.one $.support.transition.end, superFunction
