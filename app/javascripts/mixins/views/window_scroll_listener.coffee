Radium.WindowScrollListener = Ember.Mixin.create
  bindScrolling: (name = 'default') ->
    onScroll = =>
      Ember.run.scheduleOnce 'afterRender', this, 'scrolled'

    $(document).bind("touchmove.#{name}", onScroll)
    $(window).bind("scroll.#{name}", onScroll)

  scrolled: ->
    throw new Error('You need to override scrolled in the WindowScrollListener')

  unbindScrolling: (name = 'default') ->
    $(document).unbind("touchmove.#{name}")
    $(window).unbind("scroll.#{name}")
