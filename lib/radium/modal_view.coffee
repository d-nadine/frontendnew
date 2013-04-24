Radium.ModalView = Radium.View.extend
  layout: Ember.Handlebars.compile """
    <div class="modal-backdrop">
      {{yield}}
    </div>
  """

  didInsertElement: ->
    @$('.modal').addClass('in')

  destroy: ->
    if @get('state') isnt 'inDOM' then @_super()

    @$().one $.support.transition.end, @_super.bind(this)

    @$('.modal').removeClass('in')


