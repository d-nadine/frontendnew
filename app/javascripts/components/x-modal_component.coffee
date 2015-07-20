Radium.XModalComponent = Ember.Component.extend
  actions:
    closeModal: ->
      @sendAction "close"

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @$('.modal').addClass('in')

    self = this

    Ember.run.next ->
      $('body').on 'click.xmodal', (e) ->
        target = $(e.target)

        if target.parents('.xmodal-component').length
          return true

        self.send "closeModal"

        e.stopPropagation()
        e.preventDefault()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    $('body').off 'click.xmodal'

  destroy: ->
    if @get('_state') isnt 'inDOM' then @_super()

    unless modal = @$('.modal')
      return

    modal.removeClass('in')

    # FIXME: __nextSuper will break in a future
    # ember release
    superFunction = @__nextSuper.bind this

    modal.one $.support.transition.end, superFunction

