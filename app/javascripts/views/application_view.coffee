Radium.ApplicationView = Em.View.extend
  templateName: 'radium/application'
  didInsertElement: ->
    scroller = $('#scrollarea').tinyscrollbar()
    @set('scroller', scroller )

    $(window).on('resize', =>
      @get('scroller').tinyscrollbar_update()) if @get('scroller')

  willDestroyElement: ->
    $(window).off('resize')
    $('.thumb').off('contentScrolled')
    @get('scroller').unbindAll() if @get('scroller')
    scrollContainer = $('.scrollcontainer')
    scrollContainer.find("*").andSelf().unbind()
    scrollContainer.remove()
