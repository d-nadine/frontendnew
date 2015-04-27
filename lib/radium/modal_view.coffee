Radium.ModalView = Radium.View.extend
  layout: Ember.Handlebars.compile """
    <div class="modal-backdrop">
      <div class="modal fade">
        {{yield}}
      </div>
    </div>
  """

  didInsertElement: ->
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

    @$().one $.support.transition.end, superFunction
