Radium.FlashView = Ember.View.extend
  classNames: 'alert fade'
  classNameBindings: 'controller.type'
  templateName: 'flash'

  didInsertElement: ->
    @$()[0].offsetWidth
    @$().addClass('in')

    timer = setTimeout(=>
      @close()
    , 4000)

    @set('timer', timer)

  willDestroyElement: ->
    clearTimeout(@get('timer'))
    @$().off($.support.transition.end)

  # For this to work, ensure that the flash message is placed in a `flash` outlet
  close: ->
    @$().one($.support.transition.end, =>
      @get('parentView').disconnectOutlet('flash')
    ).removeClass('in')
