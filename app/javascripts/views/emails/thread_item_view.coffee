Radium.ThreadItemView = Radium.View.extend
  selectedEmail: Ember.computed.oneWay 'controller.selectedEmail'
  currentEmail: Ember.computed.oneWay 'controller.model'
  hasScrolled: Ember.computed.alias 'parentView.hasScrolled'
  isSelected: Ember.computed.oneWay 'controller.isSelected'
  lastEmail: Ember.computed.oneWay 'controller.controllers.emailsThread.lastObject'
  currentPage: Ember.computed.oneWay 'controller.controllers.emailsThread.page'

  setup: (->
    if @get('currentPage') == 1 && (@get('currentEmail') == @get('lastEmail'))
      Ember.run.scheduleOnce 'afterRender', this, 'scrollToTop'
  ).on 'didInsertElement'

  scrollToTop: ->
    window.scrollTo(0,0)
