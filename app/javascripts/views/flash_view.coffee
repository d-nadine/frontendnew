Radium.FlashView = Ember.View.extend
  actions:
    close: ->
      @$().one($.support.transition.end, =>
        @get('parentView').disconnectOutlet('flash')
      ).removeClass('in')
      return

  classNames: 'alert fade'
  classNameBindings: 'controller.type'
  templateName: 'flash'

  didInsertElement: ->
    @$()[0].offsetWidth
    @$().addClass('in')

    timer = setTimeout(=>
      @send 'close'
    , 4000)

    @set('timer', timer)

  willDestroyElement: ->
    clearTimeout(@get('timer'))
    @$().off($.support.transition.end) 
