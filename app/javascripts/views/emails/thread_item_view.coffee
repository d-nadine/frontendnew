Radium.ThreadItemView = Radium.View.extend Radium.GetEmailCoords,
  currentEmail: Ember.computed.oneWay 'controller.model'
  emailsThread: Ember.computed.alias 'controller.controllers.emailsThread'
  currentPage: Ember.computed.oneWay 'controller.controllers.emailsThread.page'

  setup: (->
    Ember.run.scheduleOnce 'afterRender', this, 'scrollToFirstEmail'
  ).on 'didInsertElement'

  scrollToFirstEmail: ->
    email = @get('currentEmail')
    currentPage = @get('currentPage')

    # scroll to last email
    setTimeout =>
      if @get('currentPage') == 1 && (@get('currentEmail') == @get('emailsThread.lastObject'))
        selector = ".email-history [data-id='#{email.get('id')}']"
        ele = $(selector).get(0)
        Ember.$.scrollTo("##{ele.id}", 0, {offset: -100})
        return

      if @get('currentPage') == 1 & email == @get('emailsThread.firstObject')
        $(window).on "scroll.regularScroller", @didScroll.bind(this)
    , 200

  didScroll: ->
    firstInThread = @get('emailsThread.firstObject')
    subject = firstInThread.get('subject')

    selector = selector = ".email-history [data-id='#{firstInThread.get('id')}']"
    ele = $(selector)

    top = ele.offset().top + (ele.outerHeight(true))

    scrollTop = $(window).scrollTop()

    return if scrollTop == 0

    if scrollTop <= top
      @teardown()

      emails = @get('emailsThread.model')

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
        return if @get('emailsThread.isLoading')

        @removeObserver 'emailsThread.isLoading', observer

        setTimeout ->
          ele = $(current.selector)

          onAfter = ->
            $(window).on "scroll.regularScroller", self.didScroll.bind(self)

          Ember.$.scrollTo("##{ele.get(0).id}", 0, {offset: -200, onAfter: onAfter})
        , 400

      @addObserver('emailsThread.isLoading', observer)
      @get('emailsThread').send 'showMore'

  teardown: ( ->
    $(window).off ".regularScroller"
  ).on 'willDestroyElement'
