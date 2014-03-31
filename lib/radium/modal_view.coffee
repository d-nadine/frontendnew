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
    if @get('state') isnt 'inDOM' then @_super()

    @$('.modal').removeClass('in')

    superFunction = @__nextSuper.bind this

    @$().one $.support.transition.end, superFunction

