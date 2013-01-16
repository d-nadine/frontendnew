Radium.SidebarScrollbarMixin = Em.Mixin.create
  scroller: null

  didInsertElement: ->
    @shouldScroll()

    $(window).on 'resize', =>
      @shouldScroll.call(this)

  shouldScroll: ->
    if $('.overview').height() < $('#scrollarea').height()
      @removeScrolling.call(this) if @get('scroller')
      return

    if @get('scroller')
      @get('scroller').tinyscrollbar_update()
      return

    scroller = $('#scrollarea').tinyscrollbar()
    $('#scrollarea .scrollbar').show()
    @set('scroller', scroller )

  removeScrolling: ->
    @get('scroller').unbindAll() if @get('scroller')
    $('#scrollarea .scrollbar').hide()
    $('.scrollcontainer').find("*").andSelf().unbind()
    @set('scroller', null)

  willDestroyElement: ->
    @removeScrolling()
    $(window).off('resize', @shouldScroll)
