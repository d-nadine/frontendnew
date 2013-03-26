Radium.MessagesEmailController = Ember.ObjectController.extend
  activeDeal: Ember.computed.alias('contact.deals.firstObject')
  nextTask: Ember.computed.alias('contact.nextTask')

  showHud: (-> 
    !Ember.isNone(@get('contact'))
  ).property('contact')

  history: (->
    Radium.Email.find historyFor: @get('model')
  ).property('model')
