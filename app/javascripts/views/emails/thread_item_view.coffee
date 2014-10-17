Radium.ThreadItemView = Radium.View.extend
  currentEmail: Ember.computed.oneWay 'controller.model'
  emailsThread: Ember.computed.alias 'controller.controllers.emailsThread'

  currentPage: Ember.computed.oneWay 'controller.controllers.emailsThread.page'

  setup: (->
    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTop'
  ).on 'didInsertElement'

  scrollToTop: ->
    email = @get('currentEmail')

    setTimeout =>
      if @get('currentPage') == 1 && (@get('currentEmail') == @get('emailsThread.lastObject'))
        p email.get('subject')
        selector = ".email-history [data-id='#{email.get('id')}']"
        ele = $(selector).get(0)
        Ember.$.scrollTo("##{ele.id}", 0, {offset: -100})
        return

      # if email == @get('lastEmail')
      #   $(window).on "scroll.regularScroller#{email.get('id')}", @didScroll.bind(this)
    , 200

  didScroll: ->
    @get('currentEmail.subject')

  teardown: ( ->
    $(window).off "scroll.regularScroller#{email.get('id')}", @didScroll.bind(this)
  )