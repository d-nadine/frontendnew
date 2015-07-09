Radium.EmailsThreadView = Radium.View.extend Radium.GetEmailCoords,
  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'addListeners'

  addListeners: ->
    win = $(window)
    win.off "scroll.regularScroller"
    win.off "resize.right"
    win.on "scroll.regularScroller", @didScroll.bind(this)
    win.on "resize.right", @resizeRightColumn.bind(this)

  resizeRightColumn: (e) ->
    return unless right = @$('.right-column')

    height = $(window).height() - right.position().top - 20

    right.height(height)

  didScroll: ->
    return if @get('controller.allPagesLoaded')
    return unless @get('controller.initialised')

    firstInThread = @get('controller.firstObject')

    selector = selector = ".email-history [data-id='#{firstInThread.get('id')}']"
    ele = $(selector)

    top = ele.offset().top + (ele.outerHeight(true))

    scrollTop = $(window).scrollTop()

    return if scrollTop == 0

    if scrollTop <= top
      @teardown()

      emails = @get('controller.model')

      emailCoords = @getEmailCoords(emails)

      unless emailCoords.length
        return @addListener()

      current = emailCoords.find (coord) ->
        scrollTop >= coord.top && scrollTop <= coord.bottom

      unless current
        return @addListeners()

      index = emailCoords.indexOf current

      current = emailCoords[index + 1]

      unless current
        return @addListeners()

      self = this
      observer = =>
        return if @get('controller.isLoading')

        @removeObserver 'controller.isLoading', observer

        setTimeout ->
          ele = $(current.selector)

          onAfter = ->
            self.addListeners()

          return onAfter() unless ele

          Ember.$.scrollTo("##{ele.get(0).id}", 0, {offset: 0, onAfter: onAfter})
        , 200

      @addObserver('controller.isLoading', observer)
      @get('controller').send 'showMore'

  teardown: Ember.on 'willDestroyElement', ->
    $(window).off ".regularScroller"
    $('resize.right').off 'resize'
