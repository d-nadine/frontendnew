Radium.MessagesEmailController = Ember.ObjectController.extend
  activeDeal: Ember.computed.alias('sender.deals.firstObject')
  nextTask: Ember.computed.alias('sender.nextTask')

  sender: Ember.computed.alias('firstObject.sender')

  history: (->
    Radium.Email.find historyFor: @get('model')
  ).property('model')
