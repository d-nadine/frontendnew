Radium.EmailsThreadView = Radium.View.extend Radium.GetEmailCoords,
  setup: (->
    Ember.run.scheduleOnce 'afterRender', this, 'addListener'
  ).on 'didInsertElement'

  addListener: ->
    $(window).on "scroll.regularScroller", @didScroll.bind(this)

  didScroll: ->
    firstInThread = @get('controller.firstObject')
    subject = firstInThread.get('subject')

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
        return

      current = emailCoords.find (coord) ->
        scrollTop >= coord.top && scrollTop <= coord.bottom

      return unless current

      index = emailCoords.indexOf current

      current = emailCoords[index + 1]

      self = this
      observer = =>
        return if @get('controller.isLoading')

        @removeObserver 'controller.isLoading', observer

        setTimeout ->
          ele = $(current.selector)

          onAfter = ->
            return if self.controller.get('allPagesLoaded')

            $(window).on "scroll.regularScroller", self.didScroll.bind(self)

          Ember.$.scrollTo("##{ele.get(0).id}", 0, {offset: 0, onAfter: onAfter})
        , 200

      @addObserver('controller.isLoading', observer)
      @get('controller').send 'showMore'

  teardown: ( ->
    $(window).off ".regularScroller"
  ).on 'willDestroyElement'
