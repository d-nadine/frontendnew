Radium.ThreadItemView = Radium.View.extend
  selectedEmail: Ember.computed.oneWay 'controller.selectedEmail'
  currentEmail: Ember.computed.oneWay 'controller.model'
  hasScrolled: Ember.computed.alias 'parentView.hasScrolled'
  isSelected: Ember.computed.oneWay 'controller.isSelected'
  lastEmail: Ember.computed.oneWay 'controller.controllers.emailsThread..sortedReplies.lastObject'
  currentPage: Ember.computed.oneWay 'controller.controllers.emailsThread.page'

  setup: (->
    if @get('currentPage') == 1 && (@get('currentEmail') == @get('lastEmail'))
      Ember.run.scheduleOnce 'afterRender', this, 'scrollToTop'
  ).on 'didInsertElement'

  scrollToTop: ->
    email = @get('currentEmail')

    setTimeout ->
      selector = ".email-history [data-id='#{email.get('id')}']"
      ele = $(selector).get(0)
      Ember.$.scrollTo("##{ele.id}", 0, {offset: -100})
    , 200
