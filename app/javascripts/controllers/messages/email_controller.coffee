Radium.MessagesEmailController = Ember.ObjectController.extend
  activeDeal: Ember.computed.alias('sender.deals.firstObject')
  nextTask: Ember.computed.alias('sender.nextTask')

  history: (->
    Radium.Email.find historyFor: @get('model')
  ).property('model')
