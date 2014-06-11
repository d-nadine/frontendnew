Radium.ThreadItemView = Radium.View.extend
  selectedEmail: Ember.computed.oneWay 'controller.selectedEmail'
  currentEmail: Ember.computed.oneWay 'controller.model'
  hasScrolled: Ember.computed.alias 'parentView.hasScrolled'
