Radium.ThreadItemView = Radium.View.extend
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
    , 200